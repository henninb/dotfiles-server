# Disable the default fish greeting
set -g fish_greeting ""

if test -f /etc/os-release
    set -gx OS (grep '^NAME=' /etc/os-release | tr -d '"' | cut -d = -f2)
else if type lsb_release >/dev/null 2>&1
    set -gx OS (lsb_release -si)
else if test -f /etc/lsb-release
    set -gx OS (grep '^DISTRIB_ID=' /etc/lsb-release | tr -d '"' | cut -d = -f2)
else if test -f /etc/debian_version
    set -gx OS Debian
else
    # FreeBSD, OpenBSD, Darwin branches here.
    set -gx OS (uname -s)
end

if test "$OS" = "openSUSE Tumbleweed"
    set -x NIX_SSL_CERT_FILE /var/lib/ca-certificates/ca-bundle.pem
end

if test "$TERM" = dumb
    set -x PS1 '$ '
end

function gitpush
    if test (count $argv) -lt 1
        echo "Usage: gitpush <messages>" >&2
    else
        git pull origin main
        git add .
        git commit -m "$argv"
        git push origin main
    end
end

test -f $HOME/.alias-fish; and source $HOME/.alias-fish

if test -x (command -v nvim); and test -f $HOME/.alias-neovim.fish
    source $HOME/.alias-neovim.fish
end

if test "$OS" = FreeBSD -o "$OS" = "Alpine Linux" -o "$OS" = OpenBSD -o "$OS" = Darwin
    source $HOME/.alias-bsd-fish
end

if test "$OS" = Gentoo
    if command -v java-config >/dev/null 2>&1
        set -gx JAVA_HOME (java-config -o 2>/dev/null)
    end
else if test "$OS" = FreeBSD
    set -gx JAVA_HOME /usr/local/openjdk21
else if test "$OS" = "Void"
    for jvm_dir in /usr/lib/jvm/openjdk21 /usr/lib/jvm/java-21-openjdk
        if test -d "$jvm_dir"
            set -gx JAVA_HOME $jvm_dir
            break
        end
    end
else if command -v archlinux-java >/dev/null 2>&1
    set -gx JAVA_HOME /usr/lib/jvm/(archlinux-java get 2>/dev/null)
else if command -v javac >/dev/null 2>&1
    set -gx JAVA_HOME (dirname (dirname (readlink -f (readlink -f (which javac)))) 2>/dev/null)
end
# else if test (uname) = "Darwin"
#   set -gx JAVA_HOME (/usr/libexec/java_home)

if test "$OS" = FreeBSD
    set -gx DOCKER_HOST ssh://henninb@debian-dockerserver
end

# Add directories to PATH only if they exist
for dir in \
    /opt/brave-browser \
    /opt/brave-bin \
    /opt/ki/bin \
    /opt/zoom \
    /opt/mullvad-browser/Browser \
    /opt/google-cloud-sdk/bin \
    $HOME/Applications \
    /opt/yubico-authenticator \
    $HOME/.ghcup/bin \
    $HOME/.nix-profile/bin \
    $HOME/scripts \
    $HOME/python/streamdeck-env/bin \
    $HOME/.local/share/bin \
    $PYENV_ROOT/bin \
    $HOME/.local/bin \
    /usr/local/opt/openjdk@17/bin \
    $HOME/.local/share/npm/bin \
    $HOME/.local/share/cargo/bin \
    $HOME/.rvm/bin \
    /opt/kafka/bin \
    /opt/charles/bin \
    /opt/flutter/bin \
    /opt/android-studio/bin \
    /opt/kafka-client/bin \
    /opt/kotlinc/bin \
    /opt/sbt/bin \
    /opt/oracle-instantclient \
    $HOME/.dynamic-colors/bin \
    /usr/local/go/bin \
    /usr/local/bin \
    /usr/sbin \
    /sbin \
    /opt/fastly/bin \
    $HOME/.local/share/JetBrains/Toolbox/scripts
    test -d "$dir"; and set -x PATH $dir $PATH
end
# Add JAVA_HOME/bin if JAVA_HOME is set and exists
test -n "$JAVA_HOME" -a -d "$JAVA_HOME/bin"; and set -x PATH $JAVA_HOME/bin $PATH

set -gx CDPATH ~/projects/github.com

if test -d /usr/local/go
    set -gx GOROOT /usr/local/go
end

set -gx GOPATH $HOME/.local

# Tells 'less' not to paginate if less than a page
set -gx LESS "-F -X $LESS"

set -gx CHEF_USER (whoami)
set -gx NVM_DIR "$HOME/.nvm"
set -gx TMOUT 0
set -gx GPG_TTY (tty)
# set -x PYENV_ROOT "$HOME/.pyenv"
set -gx VAGRANT_DEFAULT_PROVIDER kvm
# TODO is this required
set -gx POWERLINE_BASH_CONTINUATION 1
set -gx POWERLINE_BASH_SELECT 1
set -gx KEYTIMEOUT 1

set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx XDG_CACHE_HOME "$HOME/.cache"

set -gx ANDROID_AVD_HOME "$HOME/.config/.android/avd"
#set -gx ANDROID_HOME "$XDG_DATA_HOME"/android
set -gx ANDROID_HOME "$HOME"/Android/Sdk
set -gx AWS_SHARED_CREDENTIALS_FILE "$XDG_CONFIG_HOME"/aws/credentials
set -gx AWS_CONFIG_FILE "$XDG_CONFIG_HOME"/aws/config
set -gx HISTFILE "$XDG_STATE_HOME"/zsh/history
set -gx CARGO_HOME "$XDG_DATA_HOME"/cargo
set -gx SDKMAN_DIR "$XDG_DATA_HOME"/sdkman
set -gx RUSTUP_HOME "$XDG_DATA_HOME"/rustup
set -gx AZURE_CONFIG_DIR "$XDG_DATA_HOME"/azure
set -gx PSQLRC "$XDG_CONFIG_HOME/pg/psqlrc"
set -gx PSQL_HISTORY "$XDG_DATA_HOME/psql_history"
set -gx PGPASSFILE "$XDG_CONFIG_HOME/pg/pgpass"
set -gx _JAVA_OPTIONS -Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
set -gx STACK_ROOT "$XDG_DATA_HOME"/stack
set -gx NVM_DIR "$XDG_DATA_HOME"/nvm
set -gx _Z_DATA "$XDG_DATA_HOME/z"
set -gx TERMINFO "$XDG_DATA_HOME"/terminfo
set -gx TERMINFO_DIRS "$XDG_DATA_HOME"/terminfo:/usr/share/terminfo
set -gx LEIN_HOME "$XDG_DATA_HOME"/lein
set -gx GRADLE_USER_HOME "$XDG_DATA_HOME"/gradle
set -gx SCREENRC "$XDG_CONFIG_HOME"/screen/screenrc
set -gx PYENV_ROOT "$XDG_DATA_HOME"/pyenv
set -gx NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME"/npm/npmrc
# set -x GNUPGHOME "$XDG_DATA_HOME"/gnupg
set -gx GTK2_RC_FILES "$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
set -gx SSH_AUTH_SOCK /run/user/1000/keyring/ssh

# Enable headless mode for inbox-cleaner (bypass keyring)
set -gx HEADLESS true

# Kubernetes configuration for Talos cluster
set -gx KUBECONFIG /home/henninb/.kube/config

# Cribbage App Signing Configuration
set -gx CRIBBAGE_KEYSTORE_PATH "$HOME/.android/keystores/cribbage-release-key.jks"
set -gx CRIBBAGE_KEY_ALIAS "cribbage-release"

# Android SDK paths (only if ANDROID_HOME is set)
if test -n "$ANDROID_HOME"
    for dir in $ANDROID_HOME/cmdline-tools/latest/bin $ANDROID_HOME/emulator $ANDROID_HOME/platform-tools
        test -d "$dir"; and set -x PATH $dir $PATH
    end
end

test -s "$HOME/.fzf/shell/key-bindings.fish"; and source "$HOME/.fzf/shell/key-bindings.fish"
test -s "$HOME/.nix-profile/etc/profile.d/nix.fish"; and source "$HOME/.nix-profile/etc/profile.d/nix.fish"
test -s "$HOME/.cargo/env"; and source "$HOME/.cargo/env"
test -s "$SDKMAN_DIR/bin/sdkman-init.fish"; and source "$SDKMAN_DIR/bin/sdkman-init.fish"

# Source secrets file (not in git)
if test -f ~/.config/fish/secrets.fish
    source ~/.config/fish/secrets.fish
end

# Everything below only runs in interactive sessions
if not status is-interactive
    exit
end


if test (uname) = Linux
    if test -f /sys/module/hid_apple/parameters/fnmode
        if not cat /sys/module/hid_apple/parameters/fnmode | grep -q 2
            echo 2 | sudo tee /sys/module/hid_apple/parameters/fnmode
            if not grep -q '^options hid_apple fnmode=2$' /etc/modprobe.d/hid_apple.conf
                echo 'options hid_apple fnmode=2' | sudo tee -a /etc/modprobe.d/hid_apple.conf
            end

            if command -v update-initramfs
                sudo update-initramfs -u -k all
            else if command -v mkinitcpio
                sudo mkinitcpio -p linux
            else if command -v genkernel
                sudo genkernel initramfs
            else if command -v xbps-reconfigure
                sudo xbps-reconfigure -f linux6.1
            else if command -v dracut
                if not grep -q '^hostonly=yes$' /etc/dracut.conf.d/manual.conf
                    echo 'hostonly=yes' | sudo tee -a /etc/dracut.conf.d/manual.conf
                end
                sudo dracut -f --regenerate-all
            else
                echo "kernel generate not found"
            end
            echo reboot
        end
    end
end

#test -s "$NVM_DIR/nvm.sh"; and chmod 755 "$NVM_DIR/nvm.sh"; and source "$NVM_DIR/nvm.sh"
test ! -f "$HOME/.ssh/id_rsa.pub"; and ssh-keygen -y -f "$HOME/.ssh/id_rsa" >"$HOME/.ssh/id_rsa.pub"
test -f "$HOME/.ssh/id_ed25519"; and test ! -f "$HOME/.ssh/id_ed25519.pub"; and ssh-keygen -y -f "$HOME/.ssh/id_ed25519" >"$HOME/.ssh/id_ed25519.pub"
test ! -d "$XDG_DATA_HOME/pyenv"; and git clone https://github.com/pyenv/pyenv.git "$XDG_DATA_HOME/pyenv"


test -f /opt/arduino/arduino; and ln -sfn /opt/arduino/arduino "$HOME/.local/bin/arduino" 2>/dev/null
test -f /opt/intellij/bin/idea; and ln -sfn /opt/intellij/bin/idea "$HOME/.local/bin/intellij" 2>/dev/null
test -f /opt/android-studio/bin/studio.sh; and ln -sfn /opt/android-studio/bin/studio.sh "$HOME/.local/bin/android-studio" 2>/dev/null
test -f /opt/firefox/firefox; and ln -sfn /opt/firefox/firefox "$HOME/.local/bin/firefox" 2>/dev/null
test -f /opt/vscode/bin/code; and ln -sfn /opt/vscode/bin/code "$HOME/.local/bin/code" 2>/dev/null
test -f /usr/bin/vscodium; and ln -sfn /usr/bin/vscodium "$HOME/.local/bin/code" 2>/dev/null
test -f "$HOME/.tmux-default.conf"; and ln -sfn "$HOME/.tmux-default.conf" "$HOME/.tmux.conf" 2>/dev/null
test -f "$HOME/.ssh/config"; and chmod 600 "$HOME/.ssh/config"
test -f "$HOME/.ssh/authorized_keys"; and chmod 600 "$HOME/.ssh/authorized_keys"
test -f "$HOME/.ssh/id_rsa"; and chmod 600 "$HOME/.ssh/id_rsa"
test -f "$HOME/.ssh/id_ed25519"; and chmod 600 "$HOME/.ssh/id_ed25519"
test -d "$HOME/.ssh"; and chmod 700 "$HOME/.ssh"
chmod 700 "$HOME"
test -d "$HOME/.gnupg"; and chmod 700 "$HOME/.gnupg"
test -f "$HOME/.ghci"; and chmod 644 "$HOME/.ghci"


# vim keybindings
fish_vi_key_bindings

# emacs keybindings - fish_key_reader
bind -M insert \ca beginning-of-line
bind -M insert \ce end-of-line
bind -M insert \cw backward-kill-word
bind -M insert \ck kill-line
# for mode in (bind -L)
# end

# Color overrides (these override fish_frozen_theme.fish)
# Remove or comment out if you want to use the frozen theme colors
set -g fish_color_command green
set -g fish_color_param blue
set -g fish_color_end white

if set -q SSH_CLIENT
    echo "This is an SSH session." >/dev/null
else if set -q SSH_CONNECTION
    echo "This is an SSH session." >/dev/null
end

function decode_base64_url
    set len (math "$argv[1]" % 4)
    set result $argv[1]

    switch $len
        case 2
            set result "$argv[1]"'=='
        case 3
            set result "$argv[1]"'='
    end

    echo $result | tr _- '/+' | openssl enc -d -base64
end

function decode_jwt
    decode_base64_url (echo -n $argv[2] | cut -d "." -f $argv[1]) | jq .
end

starship init fish | source

# vim: set ft=fish:
