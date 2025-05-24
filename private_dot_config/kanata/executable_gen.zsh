#!/usr/bin/zsh

s() { echo "(cmd bash -c \"$1\")" }
sm() { echo "(cmd swaymsg $1)" }
e() { echo "(cmd swaymsg exec -- ${@:1})" }
onesh() { echo "(multi $1 (layer-switch default))" }
swmg() {
    s "/home/caio/.cargo/bin/sway-workspace-manager $1 &>/dev/null || /home/caio/.cargo/bin/sway-workspace-manager $2 &>/dev/null"
}
sfork() { echo "(fork $1 $2 (lsft rsft))" }
cfork() { echo "(fork $1 $2 (lctl rctl))" }
afork() { echo "(fork $1 $2 (lalt ralt))" }
rssw() { sm "resize shrink width ${1}px" }
rssh() { sm "resize shrink height ${1}px" }
rsgw() { sm "resize grow width ${1}px" }
rsgh() { sm "resize grow height ${1}px" }
mdsw() { echo "(multi (layer-switch sway) $(s 'echo on >/tmp/sway-indicator-socket'))" }
mddf() { echo "(multi (layer-switch default) $(s 'echo off >/tmp/sway-indicator-socket'))" }

echo "
(defcfg
    linux-dev /dev/input/by-id/usb-SONiX_USB_DEVICE-event-kbd
    process-unmapped-keys yes
    allow-hardware-repeat false
    danger-enable-cmd yes)
(deflocalkeys-linux
    apostrof 41
    backslash 86
    semicolon 53
    slash 89
    ccedilha 39
    agudo 26
    tilde 40
    brleft 27
    brright 43
)
(defsrc lmet menu $(for n in $(seq 9); do echo "f${n} kp${n}"; done))
(deflayer default $(mdsw) $(mdsw) $(for n in $(seq 9); do echo "kp${n} f${n}"; done))
(deflayermap (sway)
    h $(sfork "$(sm "focus left")" "$(cfork \
            "$(sm "move left 20px")" \
            "$(sm "move left 1px")" \
        )")
    j $(sfork "$(sm "focus down")" "$(cfork \
            "$(sm "move down 20px")" \
            "$(sm "move down 1px")" \
        )")
    k $(sfork "$(sm "focus up")" "$(cfork \
            "$(sm "move up 20px")" \
            "$(sm "move up 1px")" \
        )")
    l $(sfork "$(sm "focus right")" "$(cfork \
            "$(sm "move right 20px")" \
            "$(sm "move right 1px")" \
        )")
    g $(sfork "$(rsgw 1)" "$(rsgw 20)")
    s $(sfork "$(rssw 1)" "$(rssw 20)")
    brleft $(sfork "$(rsgh 1)" "$(rsgh 20)")
    brright $(sfork "$(rssh 1)" "$(rssh 20)")
    , $(sfork "$(swmg "switch prev" "create prev")" "$(swmg "move prev" "move-to-new prev")")
    . $(sfork "$(swmg "switch next" "create next")" "$(swmg "move next" "move-to-new next")")
    u $(e kitty)
    o $(e chromium)
    p $(e google-chrome-stable)
    i $(e kitty nvim-forever)
    y $(e kitty yazi)
    t $(e kitty top)
    z $(e zathura)
    v $(e pavucontrol-qt)
    f12 $(e fnotctl mode -t silent)
    f11 $(e fnotctl dismiss all)
    f9 $(e fnotctl dismiss)
    f10 $(e fnotctl restore)
    ret $(onesh "$(e fuzzel)" )
    tilde $(sm 'floating toggle')
    agudo $(sm 'border toggle')
    f5 $(sm reload)
    
    bspc $(sm kill)
    lsft lsft
    rsft rsft
    lctl lctl
    rctl rctl
    lalt lalt
    ralt ralt
    esc $(mddf)
    caps $(mddf)
    lmet $(mddf)
    menu $(mddf)
    ___ XX)
"

