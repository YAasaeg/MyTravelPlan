# 

这是一个基于 OpenHarmony 的旅游计划应用程序。结合了本地数据库存储和 AI 智能对话功能，帮助用户轻松制定和管理旅游行程。

## 主要功能

*   **用户管理**
    *   用户注册与登录
    *   个人信息管理
    *   基于 SQLite 的本地用户数据存储

*   **旅游计划管理**
    *   创建新的旅游计划（标题、内容、日期）
    *   查看历史旅游计划列表
    *   查看计划详情
    *   数据持久化存储

*   **AI 智能助手**
    *   集成 DeepSeek AI 接口
    *   智能对话，获取旅游建议
    *   支持上下文的聊天记录保存

##  应用截图

<div align="center">
  <img src="screenshots/Login.png" width="200" alt="登录页" />
  <img src="screenshots/Plan.png" width="200" alt="计划页" />
  <img src="screenshots/Chat.png" width="200" alt="AI对话页" />
  <img src="screenshots/Profile.png" width="200" alt="个人信息页" />
</div>

## 技术栈

*   **开发语言**: ArkTS (TypeScript)
*   **UI 框架**: ArkUI
*   **构建工具**: Hvigor
*   **数据库**: RelationalStore (RDB)
*   **网络通信**: @ohos.net.http
*   **AI 服务**: DeepSeek API

##  项目结构

```
d:\MyTravelPlan
├── AppScope/               # 全局应用配置
├── entry/
│   └── src/main/ets/
│       ├── components/     # UI 组件 (ChatView, PlanCard, etc.)
│       ├── db/            # 数据库管理 (DatabaseManager)
│       ├── entryability/   # 应用入口 Ability
│       ├── model/          # 数据模型 (User, Plan, ChatMessage)
│       ├── pages/          # 页面 (Index, LoginPage)
│       └── utils/          # 工具类 (DeepSeekService, Theme)
└── oh_modules/             # 第三方依赖
```

## 快速开始

### 环境要求

*   DevEco Studio
*   HarmonyOS SDK (API 13+)

### 安装步骤

1.  克隆或下载本项目代码。
2.  使用 DevEco Studio 打开项目目录 `d:\MyTravelPlan`。
3.  等待 Sync 完成，下载必要的依赖。
4.  配置签名（如需真机调试）。
5.  点击运行 (Run) 按钮启动应用。

### 注意事项

*   **API Key**: 项目目前在 `DeepSeekService.ets` 中使用了硬编码的 API Key。在实际部署或公开代码前，请确保替换为您自己的 Key，并建议将其移至配置文件或环境变量中以保证安全。
*   **网络权限**: 应用需要联网权限 (`ohos.permission.INTERNET`) 才能访问 AI 服务。

##  待办事项

*   添加更多 AI 对话模型支持
*   增加计划提醒功能
*   优化 UI/UX 设计

## 
本项目仅供学习和演示使用。
