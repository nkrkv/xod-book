
## Toolchain

- `texlive-core`
- `texlive-latexextra`

## Emoji

A package to convert emoji unicode code points to corresponding images from `emoji` are taken from <https://github.com/mreq/xelatex-emoji>. Resides in `./texmf/xelatexemoji*.sty`. A package to convert verbose codenames as seen on <https://emojipedia.org> to particular unicode characters is hand-made in `./texmf/codemoji.sty`. The asset files (SVGs) are cherry-picked from Twemoji project (<https://github.com/twitter/twemoji/tree/master/assets/svg>).

To support a new emoji:

1. Explore its codename and add a line to `./texmf/codemoji.sty`
2. Pick its SVG from Twemoji repo and put it to `./emoji`
