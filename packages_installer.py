#!/usr/bin/env python3
import subprocess
import time
import re

PACMAN_PACKAGES = [
    "git", "hyprland", "waybar", "wofi", "swaync", "ranger",
    "thunar", "haruna", "smplayer", "deepin-calculator", "deepin-calendar",
    "gsimplecal", "qbittorrent", "loupe", "cliphist", "copyq", "keepassxc",
    "syncthing", "obsidian", "hyprshot", "swappy", "ntfs-3g", "duf", "dysk",
    "lact", "fastfetch", "ueberzugpp", "piper", "pipewire", "pipewire-alsa",
    "pipewire-pulse", "pipewire-jack", "wireplumber", "pavucontrol", "alacritty",
    "kitty", "engrampa", "ark", "neovim", "chromium", "steam", "os-prober", "thunar-archive-plugin",
    "otf-font-awesome", "ttf-nerd-fonts-symbols", "ttf-nerd-fonts-common", "ttf-nerd-fonts-symbols-mono",
    "noto-fonts", "noto-fonts-cjk", "gvfs", "flatpak"
]

AUR_PACKAGES = [
    "vesktop", "gpu-screen-recorder-gtk", "sublime-text", "qdiskinfo", "ayugram-desktop-git", "arc-gtk-theme"
]

LOG_FILE = "install.log"

total_download = 0.0
total_installed = 0.0
total_upgrade = 0.0

def log(package, manager, output):
    separator = f"\n{'='*20} {package} через {manager} {'='*20}\n\n"
    with open(LOG_FILE, "a") as f:
        f.write(separator)
        f.write(output)


def extract_sizes(output):
    download, installed, upgrade = 0.0, 0.0, 0.0

    for line in output.splitlines():
        if "Total Download Size:" in line:
            match = re.search(r"([\d\.]+)\s+MiB", line)
            if match:
                download = float(match.group(1))
        elif "Total Installed Size:" in line:
            match = re.search(r"([\d\.]+)\s+MiB", line)
            if match:
                installed = float(match.group(1))
        elif "Net Upgrade Size:" in line:
            match = re.search(r"([\d\.]+)\s+MiB", line)
            if match:
                upgrade = float(match.group(1))
    return download, installed, upgrade


def install_packages(packages, manager, command_list, extra_flags=None):
    """
    packages     - список пакетов
    manager      - имя менеджера для логирования
    command_list - список команд, например ["sudo", "pacman"] или ["paru"]
    extra_flags  - список дополнительных флагов, которые добавляются к команде
    """

    failed_packages = []

    for n, pckg in enumerate(packages, start=1):
        start_time = time.time()

        cmd = command_list + ["-S", "--noconfirm", "--needed"]
        if extra_flags:
            cmd += extra_flags
        cmd.append(pckg)

        result = subprocess.run(
            cmd,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True
        )

        log(pckg, manager, result.stdout)

        spent_time = round(time.time() - start_time, 1)

        global total_download, total_installed, total_upgrade

        d, i, u = extract_sizes(result.stdout)
        total_download += d
        total_installed += i
        total_upgrade += u


        if result.returncode == 0:
            status = "✅"
            msg = f"{pckg} установлено"
        else:
            status = "❌"
            msg = f"Ошибка при установке {pckg}"
            failed_packages.append(pckg)

        print(f"[{n}/{len(packages)}] {status} {msg} ({spent_time} сек)")

    return failed_packages


def main():
    open(LOG_FILE, "w").close()

    print("=== Обновление репозиториев ===\n")
    result = subprocess.run(
        ["sudo", "pacman", "-Syu", "--noconfirm", "--needed"],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True
    )
    log("Обновление репозиториев", "Pacman", result.stdout)

    print("\n=== Установка pacman пакетов ===\n")
    failed_pacman = install_packages(PACMAN_PACKAGES, "Pacman", ["sudo", "pacman"])

    print("\n=== Установка AUR пакетов через paru ===\n")
    failed_aur = install_packages(
        AUR_PACKAGES,
        "Paru",
        ["paru"],
        extra_flags=["--skipreview", "--cleanafter"]
    )

    all_failed = failed_pacman + failed_aur

    if all_failed:
        print(f"\n=== Итог: ===\n")
        print(f"Удачных: {(len(PACMAN_PACKAGES + AUR_PACKAGES)) - len(all_failed)}\n")
        print(f"Неудачных: {len(all_failed)}:")

        for p in all_failed:
            print(f" - {p}")
    else:
        print("\nВсе пакеты успешно установлены! 🎉")

    print("\n=== Очистка кэша pacman ===")
    result = subprocess.run(
        ["sudo", "pacman", "-Scc", "--noconfirm"],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True
    )
    log("Очистка кэша", "Pacman", result.stdout)
    print("✅ Кэш pacman очищен")

    print("\n=== Очистка кэша paru ===")
    result = subprocess.run(
        ["paru", "-Scc", "--noconfirm"],
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True
    )
    log("Очистка кэша", "Paru", result.stdout)
    print("✅ Кэш paru очищен")

    print("\n=== Общий объём установленных пакетов ===")
    print(f"Total Download Size:   {total_download:.2f} MiB")
    print(f"Total Installed Size:  {total_installed:.2f} MiB")
    print(f"Net Upgrade Size:      {total_upgrade:.2f} MiB")


    print(f"\nПодробности в {LOG_FILE}")


if __name__ == "__main__":
    main()
