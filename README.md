# <img src="assets/images/avatar.png" alt="icon" width="3%"/> galapsbs

> The source code of the Gala 2023 Web App

[![Linux](https://svgshare.com/i/Zhy.svg)](https://docs.microsoft.com/en-us/windows/wsl/tutorials/gui-apps)
[![Windows](https://svgshare.com/i/ZhY.svg)](https://svgshare.com/i/ZhY.svg)
[![GitHub license](https://img.shields.io/github/license/ThomasByr/galapsbs)](https://github.com/ThomasByr/galapsbs/blob/master/LICENSE)
[![GitHub commits](https://badgen.net/github/commits/ThomasByr/galapsbs)](https://GitHub.com/ThomasByr/galapsbs/commit/)
[![GitHub latest commit](https://badgen.net/github/last-commit/ThomasByr/galapsbs)](https://gitHub.com/ThomasByr/galapsbs/commit/)
[![Maintenance](https://img.shields.io/badge/maintained%3F-yes-green.svg)](https://GitHub.com/ThomasByr/galapsbs/graphs/commit-activity)

[![GitHub version](https://badge.fury.io/gh/ThomasByr%2Fgalapsbs.svg)](https://github.com/ThomasByr/galapsbs)
[![Author](https://img.shields.io/badge/author&dev-@ThomasByr-blue)](https://github.com/ThomasByr)
[![Author](https://img.shields.io/badge/author&artist-@ThomasD-blue)](https://github.com/LosKeeper)

1. [✏️ In short](#️-in-short)
2. [👩‍🏫 Usage](#-usage)
3. [💁 Get Help](#-get-help)
4. [🔰 Support](#-support)
5. [⚖️ License](#️-license)
6. [🔄 Changelog, Bugs and TODO](#-changelog-bugs-and-todo)

## ✏️ In short

> This repo is supposed to be private. It could leave this state though for showcase purposes. If you ever get access to it please do not steal all the hard work !

This repo contains all the source code and assets of the 2023 Gala Web App hosted by [Télécom Physique Strasbourg](https://www.telecom-physique.fr/). There are two (main) branches here :

- `master` which holds the said source code
- `gh-pages` which is an _up-to-date_ clone of the [`./build/web`](build/web/) folder

Normally, you would find a release version of the web app running by [galapsbs.fr](galapsbs.fr) hosted by [ionos](https://www.ionos.com/). Alternatively, find a local version running by [Github Pages](https://thomasbyr.github.io/galapsbs/).

## 👩‍🏫 Usage

Please make sure you have installed the required dependencies with :

```ps1
flutter pub get
```

Run a production version with the device of your choice with :

```ps1
flutter run -d <device> --release
```

## 💁 Get Help

> [file a new issue](https://github.com/ThomasByr/galapsbs/issues/new)

## 🔰 Support

You can find all the infos you want on the official [Flutter](https://flutter.dev/) website. To release your app, take a look at the [specific](https://docs.flutter.dev/deployment/web) documentation.

<details>
<summary>The app won't publish / show up ?</summary>

Well if you ever published your _own_ app on [Github Pages](https://pages.github.com/), there is a weird thing with absolute / relative paths. Basically what you want to do is look for (or create) the tag

```html
<base href="$PATH" />
```

and replace it with

```html
<base href="./" />
```

</details>

<details>
<summary>There is a scaling bug between Android apk and Web js App</summary>

YES

</details>

## ⚖️ License

This project is licensed under the GPL-3.0 new or revised license. Please read the [LICENSE](LICENSE) file. Specific [ASSETS LICENSE](assets/LICENSE) apply for all assets.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met :

- Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

- Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

- Neither the name of this Web App authors nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

## 🔄 Changelog, Bugs and TODO

```mermaid
gantt
    title Main Versions
    dateFormat YYYY-MM-DD

    section source Code v1.0.0
    Android version : 2022-06-01, 3d
    iOS version     : 2022-06-02, 2d
    Web App         : 2022-06-01, 4d
    Testing         : 2022-06-03, 2d

    section Production release
    Web App      : 2022-06-03, 1d
    Github Pages : 1d
    IONOS        : 2022-06-03, 1d

```

**Bugs** - first fix patch version

- events won't load

**TODO** - first implementation version

- [ ] stable release for larger screens
- [ ] proper pre-cache for large assets / image compression
- [ ] events page
- [ ] but tickets page
