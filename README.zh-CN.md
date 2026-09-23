<p align="center">
  <img src="docs/preview.gif" width="380" alt="Octopet 预览">
</p>

<h1 align="center">Octopet 🐙</h1>

<p align="center">一只会掏出电脑敲代码的像素小章鱼，住在你的 macOS 桌面上。</p>

<p align="center"><a href="README.md">English</a> · <b>中文</b></p>

---

我觉得 Claude 的小章鱼很可爱，于是乎找 Opus 要了一个一模一样的桌面小宠物，现在分享给大家～

动画是对着 Claude 桌面端里的原版小章鱼逐帧（60fps 录屏）比对复刻的：从兜里摸索、掏出电脑、转身、敲键盘（双手轮流 + 电脑跟着抖），到合上电脑塞回兜里，都尽量还原了。另外加了一点原版没有的小私货：待机时会轻轻地上下呼吸。

## 安装

1. 到 [Releases](../../releases/latest) 下载 `Octopet-vX.Y.Z.zip`，解压得到 `Octopet.app`
2. 拖进「应用程序」文件夹
3. 第一次打开时，因为应用没有经过 Apple 公证，macOS 会拦一下：
   - 打开「系统设置 → 隐私与安全性」，在底部点「仍要打开」；或者
   - 在终端执行：`xattr -dr com.apple.quarantine /Applications/Octopet.app`

支持 macOS 11 及以上，Apple 芯片和 Intel 都可以用。

## 使用

| 操作 | 效果 |
| --- | --- |
| **单击** | 掏出电脑开始敲代码；再点一次收起来 |
| **拖动** | 把它放到屏幕任意位置 |
| **右键** | 调整大小（原版大小 / 大一点 / 超大只）、开机自动启动、退出 |

- 它会一直浮在其他窗口上面，并且在所有桌面空间都能看到
- 没有 Dock 图标，想关掉的话右键 →「再见小章鱼 👋」
- 菜单语言会跟随系统语言自动切换中文 / 英文

## 从源码构建

```bash
git clone https://github.com/1zumiii/Octopet.git
cd Octopet
scripts/build.sh        # 生成 build/Octopet.app 和 zip
swift run               # 或者直接跑起来看看
```

需要 Xcode 命令行工具（Swift 5.7+）。`scripts/preview.sh` 可以重新生成上面的动图（需要 ffmpeg）。

## 代码结构

纯 Swift + AppKit，没有任何图片素材，每一个像素都是代码画出来的：

| 文件 | 作用 |
| --- | --- |
| `Palette.swift` | 颜色和画布尺寸 |
| `Painter.swift` | 按「半格」画矩形，以及腿、身体、电脑等部件 |
| `Frame.swift` | 所有姿势（逐帧从录屏里抄下来的像素坐标） |
| `Animator.swift` | 状态机：待机 → 掏电脑 → 敲键盘 → 收电脑，60fps |
| `PetView.swift` | 透明视图：绘制、点击、拖动、右键菜单 |
| `Strings.swift` | 中英文文案 |
| `LoginItem.swift` | 开机自动启动（用户级 LaunchAgent） |

---

<sub>这是一个非官方的同人项目，与 Anthropic 无关，也未获其认可。Claude 是 Anthropic 的商标。</sub>

<sub>MIT License</sub>
