# **RSS 阅读器**

![Flutter](https://img.shields.io/badge/Flutter-3.10.0-blue)
![Platform](https://img.shields.io/badge/Platform-Android-green)
![License](https://img.shields.io/badge/License-MIT-orange)

RSS 阅读器是一款基于 Flutter 开发的移动应用，支持 Android 平台。用户可以通过该应用订阅和管理 RSS Feed，浏览最新的文章内容，并支持离线阅读和文章链接跳转。

---

## **功能特性**

- **订阅 RSS Feed**：通过 URL 订阅新的内容源。
- **浏览文章列表**：显示订阅的 RSS Feed 及其文章。
- **文章详情查看**：显示文章标题、描述和发布时间，支持链接跳转。
- **离线阅读**：所有数据存储到本地 SQLite 数据库，支持离线访问。

---

## **快速开始**

1. **克隆项目**：
   ```bash
   git clone https://github.com/xQAQyn/RSS-Reader
   cd RSS-Reader
   ```

2. **安装依赖**：
   ```bash
   flutter pub get
   ```

3. **运行项目**：
   ```bash
   flutter run
   ```

---

## **项目结构**

```
lib/
|-- main.dart                  # 应用入口
|-- models/                    # 数据模型
|-- services/                  # 服务层
|-- repositories/              # 数据仓库层
|-- widgets/                   # 自定义 Widgets
|-- views/                     # 页面视图
|-- utils/                     # 工具类
```

---

## **许可证**

[MIT 许可证](LICENSE)

---

感谢你的关注和支持！🎉
