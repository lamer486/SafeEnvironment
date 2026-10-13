#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Выпуск новой версии SkyRig Studio.

  python tools/make_release.py --src skyrig_studio_v0.51.py --notes "Что нового 1" "Что нового 2"
  python tools/make_release.py --src skyrig_studio_v0.51.py --repo ВАШ_ЛОГИН/SkyRigStudio --notes "..."

Что делает (запускать из корня репозитория):
  1. берёт файл скрипта --src, проверяет синтаксис и читает VERSION;
  2. прописывает в нём адрес обновлений вашего репозитория (--repo, запоминается в tools/repo.txt);
  3. сохраняет как skyrig_studio.py (последняя версия, из неё собираются установщики) и releases/skyrig_studio_vX.Y.py
     (на эту копию ссылается version.json);
  4. считает sha256 и пишет version.json (его читает кнопка «Обновить» в скрипте);
  5. добавляет запись в CHANGELOG.md;
  6. собирает установщики dist/SkyRigStudio.mzp и dist/SkyRigStudio_Uninstall.mzp.
Потом загрузите изменённые файлы в репозиторий (commit + push или «Upload files» на сайте GitHub).
"""
import argparse
import datetime
import hashlib
import json
import os
import re
import sys
import zipfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
REPO_FILE = os.path.join(ROOT, "tools", "repo.txt")


def read(path):
    with open(path, encoding="utf-8-sig") as f:
        return f.read()


def write(path, text):
    with open(path, "w", encoding="utf-8", newline="\n") as f:
        f.write(text)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--src", required=True, help="файл новой версии скрипта (skyrig_studio_vX.Y.py)")
    ap.add_argument("--repo", help="ЛОГИН/ИМЯ репозитория на GitHub (нужно один раз, потом запоминается)")
    ap.add_argument("--notes", nargs="*", default=[], help="что нового (каждый пункт — отдельной строкой)")
    a = ap.parse_args()

    repo = a.repo
    if not repo and os.path.isfile(REPO_FILE):
        repo = read(REPO_FILE).strip()
    if not repo or "/" not in repo:
        sys.exit("Укажите --repo ЛОГИН/ИМЯ (например kanevskiy/SkyRigStudio).")
    owner, name = repo.split("/", 1)
    write(REPO_FILE, repo + "\n")

    text = read(a.src)
    try:
        compile(text, a.src, "exec")
    except SyntaxError as ex:
        sys.exit("Ошибка синтаксиса в %s: %s" % (a.src, ex))
    m = re.search(r'^VERSION\s*=\s*"([^"]+)"', text, re.M)
    if not m:
        sys.exit("В файле не найдена строка VERSION = \"...\"")
    version = m.group(1)

    raw = "https://raw.githubusercontent.com/%s/main/version.json" % repo
    page = "https://github.com/%s" % repo
    text, n1 = re.subn(r'^UPDATE_MANIFEST_URL = ".*"$', 'UPDATE_MANIFEST_URL = "%s"' % raw, text, flags=re.M)
    text, n2 = re.subn(r'^UPDATE_PROJECT_PAGE = ".*"$', 'UPDATE_PROJECT_PAGE = "%s"' % page, text, flags=re.M)
    if n1 != 1 or n2 != 1:
        sys.exit("В скрипте не найдены строки UPDATE_MANIFEST_URL / UPDATE_PROJECT_PAGE.")

    script = os.path.join(ROOT, "skyrig_studio.py")
    write(script, text)
    with open(script, "rb") as f:
        sha = hashlib.sha256(f.read()).hexdigest()

    # копия под именем с версией: манифест ссылается на неё, поэтому кэш GitHub (до ~5 минут) не может подсунуть
    # старый файл к новому манифесту
    rel_dir = os.path.join(ROOT, "releases")
    os.makedirs(rel_dir, exist_ok=True)
    rel_name = "releases/skyrig_studio_v%s.py" % version
    write(os.path.join(ROOT, rel_name), text)

    manifest = {"version": version, "file": rel_name, "sha256": sha,
                "date": datetime.date.today().isoformat(), "notes": a.notes}
    write(os.path.join(ROOT, "version.json"), json.dumps(manifest, ensure_ascii=False, indent=2) + "\n")

    rd = os.path.join(ROOT, "README.md")                     # заготовка OWNER/SkyRigStudio -> ваш репозиторий
    if os.path.isfile(rd):
        t = read(rd)
        if "OWNER/SkyRigStudio" in t:
            write(rd, t.replace("OWNER/SkyRigStudio", repo))

    chg = os.path.join(ROOT, "CHANGELOG.md")
    old = read(chg) if os.path.isfile(chg) else "# История версий\n"
    head, _, rest = old.partition("\n")
    entry = "\n## v%s — %s\n%s\n" % (version, manifest["date"], "\n".join("- " + n for n in a.notes) or "- (без описания)")
    if ("## v%s " % version) not in old:
        write(chg, head + "\n" + entry + rest)

    dist = os.path.join(ROOT, "dist")
    os.makedirs(dist, exist_ok=True)
    inst = os.path.join(ROOT, "installer")

    def build(zip_name, files):
        p = os.path.join(dist, zip_name)
        with zipfile.ZipFile(p, "w", zipfile.ZIP_DEFLATED) as z:
            for arc, src in files:
                z.write(src, arc)
        return p

    p1 = build("SkyRigStudio.mzp", [
        ("mzp.run", os.path.join(inst, "mzp.run")),
        ("install.ms", os.path.join(inst, "install.ms")),
        ("uninstall.ms", os.path.join(inst, "uninstall.ms")),
        ("SkyRigStudio-SkyRigStudio.mcr", os.path.join(inst, "SkyRigStudio-SkyRigStudio.mcr")),
        ("skyrig_studio.py", script)])
    p2 = build("SkyRigStudio_Uninstall.mzp", [
        ("mzp.run", os.path.join(inst, "uninstall.mzp.run")),
        ("uninstall.ms", os.path.join(inst, "uninstall.ms"))])

    print("Версия:      %s" % version)
    print("sha256:      %s" % sha)
    print("Манифест:    %s" % raw)
    print("Установщики: %s, %s" % (p1, p2))
    print("Загрузите в репозиторий: skyrig_studio.py, releases/, version.json, CHANGELOG.md, dist/*.mzp")


if __name__ == "__main__":
    main()
