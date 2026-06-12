# YApi 本地开发调试指南

## 项目概述

YApi 是一个高效、易用、功能强大的 API 管理平台，旨在为开发、产品、测试人员提供更优雅的接口管理服务。

## 技术栈

| 层级 | 技术 |
|------|------|
| 后端 | Koa, mongoose (MongoDB), Node.js |
| 前端 | React, Redux, React-Router, LESS |
| 构建工具 | ykit (基于 webpack) |
| 测试 | ava |

## 环境要求

- **Node.js**: >= 7.6.0
- **npm**: >= 4.1.2
- **MongoDB**: >= 2.6
- **Git**

## 本地开发快速上手

以下步骤适用于使用 Docker 启动 MongoDB 的本地开发环境：

### 1. 启动 MongoDB 服务

```bash
docker-compose up -d
```

### 2. 安装依赖

```bash
npm install --registry https://registry.npm.taobao.org
```

### 3. 初始化数据库

```bash
npm run install-server
```

> 初始化完成后，默认管理员账号：`admin@admin.com`，密码：`ymfe.org`

### 4. 启动开发服务器

```bash
npm run dev
```

启动后访问 `http://127.0.0.1:3000`

> 初次启动会有编译过程，请耐心等候。

### 5. 停止开发环境

```bash
# 停止后端和前端开发服务器 (Ctrl+C)

# 停止 MongoDB 服务
docker-compose stop
```

---

## 使用 Docker Compose 启动 MongoDB 服务

为了快速搭建本地开发环境，推荐使用 Docker Compose 来启动 MongoDB 服务。

### 前置条件

- 已安装 [Docker](https://docs.docker.com/get-docker/)
- 已安装 [Docker Compose](https://docs.docker.com/compose/install/)

### docker-compose.yml 示例

在项目根目录创建 `docker-compose.yml` 文件，内容如下：

```yaml
version: '3.8'

services:
  mongo:
    image: mongo:4.4
    container_name: yapi-mongo
    restart: unless-stopped
    ports:
      - "27017:27017"
    volumes:
      - mongo_data:/data/db
    environment:
      MONGO_INITDB_ROOT_USERNAME: yapi
      MONGO_INITDB_ROOT_PASSWORD: yapi123
      MONGO_INITDB_DATABASE: yapi

volumes:
  mongo_data:
    driver: local
```

### 启动 MongoDB 服务

```bash
# 启动服务（后台运行）
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f mongo
```

### 停止 MongoDB 服务

```bash
# 停止服务
docker-compose stop

# 停止并删除容器（保留数据卷）
docker-compose down

# 停止并删除容器和数据卷（注意：会删除所有数据）
docker-compose down -v
```

### 验证 MongoDB 连接

```bash
# 进入容器内部使用 mongo 客户端连接
docker exec -it yapi-mongo mongosh

# 或在容器内直接验证
docker exec -it yapi-mongo bash -c 'echo "MongoDB 运行正常"'
```

### 对应 config.json 配置

使用上面的 docker-compose 配置后，对应 `config.json` 的配置如下：

```json
{
  "port": "3000",
  "adminAccount": "admin@admin.com",
  "db": {
    "servername": "127.0.0.1",
    "DATABASE": "yapi",
    "port": 27017,
    "user": "yapi",
    "pass": "yapi123",
    "authSource": "admin"
  }
}
```

> 注意：
> - 如果没有启用 MongoDB 认证，可以删除 `user`、`pass` 和 `authSource` 字段
> - `authSource` 默认是 `admin`，因为上面使用了 `MONGO_INITDB_ROOT_USERNAME` 和 `MONGO_INITDB_ROOT_PASSWORD` 环境变量

### 不启用认证的简化配置

如果只是本地开发调试，不需要认证，可以使用以下简化版 `docker-compose.yml`：

```yaml
version: '3.8'

services:
  mongo:
    image: mongo:4.4
    container_name: yapi-mongo
    restart: unless-stopped
    ports:
      - "27017:27017"
    volumes:
      - mongo_data:/data/db

volumes:
  mongo_data:
    driver: local
```

对应的 `config.json` 配置（删除认证相关字段）：

```json
{
  "port": "3000",
  "adminAccount": "admin@admin.com",
  "db": {
    "servername": "127.0.0.1",
    "DATABASE": "yapi",
    "port": 27017
  }
}
```

## 配置步骤

### 1. 复制配置文件

```bash
cp config_example.json config.json
```

### 2. 修改 config.json 配置

根据实际情况修改以下关键配置：

```json
{
  "port": "3000",                    // 服务端口
  "adminAccount": "admin@admin.com", // 管理员邮箱
  "timeout": 120000,
  "db": {
    "servername": "127.0.0.1",       // MongoDB 地址
    "DATABASE": "yapi",             // 数据库名
    "port": 27017,                  // MongoDB 端口
    "user": "your_user",            // MongoDB 用户名（可选）
    "pass": "your_pass",           // MongoDB 密码（可选）
    "authSource": ""                // 认证数据库（可选）
  },
  "mail": {                          // 邮件配置（可选）
    "enable": false,
    "host": "smtp.163.com",
    "port": 465,
    "from": "***@163.com",
    "auth": {
      "user": "***@163.com",
      "pass": "*****"
    }
  }
}
```

> 注意：如果 MongoDB 没有开启认证，请删除 `user` 和 `pass` 字段。

## 目录结构

```
yapi/
├── client/                 # 前端源码
│   ├── components/        # React 组件
│   ├── containers/        # 页面容器
│   ├── reducer/            # Redux reducers
│   ├── styles/            # 样式文件
│   └── index.js           # 前端入口
├── server/                 # 后端源码
│   ├── controllers/        # 控制器
│   ├── middleware/        # 中间件
│   ├── models/            # 数据模型
│   ├── utils/             # 工具函数
│   ├── app.js             # 后端入口
│   ├── install.js         # 数据库初始化脚本
│   ├── router.js          # 路由配置
│   ├── websocket.js       # WebSocket 处理
│   └── yapi.js            # 核心模块
├── common/                 # 公共代码
├── exts/                   # 内置扩展
├── static/                 # 静态资源
├── test/                   # 测试文件
├── docs/                   # 文档
├── config_example.json     # 配置示例
├── nodemon.json           # nodemon 配置
├── package.json           # 项目配置
├── webpack.alias.js       # webpack 别名配置
└── ykit.config.js        # ykit 构建配置
```

## 安装依赖

```bash
npm install --registry https://registry.npm.taobao.org
```

如果遇到 node-sass 安装问题（由于使用了淘宝镜像源），确保 `.npmrc` 文件中包含：

```
sass_binary_site=https://npm.taobao.org/mirrors/node-sass/
```

## 初始化数据库

```bash
npm run install-server
```

此命令会：
- 创建管理员账号（默认账号：`admin@admin.com`，密码：`ymfe.org`）
- 创建数据库索引
- 创建 `init.lock` 文件防止重复安装

如需重新安装，请先删除 `init.lock` 文件。

## 开发模式

### 启动开发服务器

```bash
npm run dev
```

该命令会同时启动：
- 后端开发服务器（nodemon 监听文件变化自动重启）
- 前端开发服务器（ykit 热更新）

启动后访问 `http://127.0.0.1:{配置的端口}`

> 初次启动会有编译过程，请耐心等候。

### 前后端分开启动（可选）

如果需要单独启动后端或前端：

```bash
# 仅启动后端（支持热重启）
npm run dev-server

# 仅启动前端（需要先安装 ykit）
npm install -g ykit
npm run dev-client
```

### nodemon 监听配置

nodemon 会监听以下目录的变化自动重启服务器：

```json
{
  "watch": ["server/", "common/", "plugins", "exts/"]
}
```

## 生产环境

### 构建前端资源

```bash
npm run build-client
```

构建产物会输出到 `static/prd/` 目录。

### 启动生产服务器

```bash
npm run start
```

或使用 pm2 管理：

```bash
npm install pm2 -g
pm2 start "node server/app.js" --name yapi
```

## 测试

```bash
npm test
```

测试文件位于 `test/` 目录，使用 ava 测试框架。

## 插件开发

YApi 支持插件扩展，详情请参考 [插件开发文档](docs/documents/plugin-dev.md)。

### 快速开始

1. 在 `vendors/node_modules/` 下创建插件目录 `yapi-plugin-demo/`
2. 目录结构：
   ```
   yapi-plugin-demo/
   ├── client.js      # 前端入口
   ├── server.js      # 后端入口
   ├── index.js       # 插件配置
   └── package.json
   ```

3. 在 `config.json` 中添加插件配置：
   ```json
   {
     "plugins": [{
       "name": "demo",
       "options": {}
     }]
   }
   ```

4. 插件入口示例 (`server.js`)：
   ```javascript
   module.exports = function(options) {
     this.bindHook('hook_name', listener);
   };
   ```

## 常见问题

### 1. 安装依赖失败

确保使用淘宝镜像：
```bash
npm install --registry https://registry.npm.taobao.org
```

### 2. MongoDB 连接失败

- 检查 MongoDB 是否启动
- 确认 `config.json` 中的数据库配置正确
- 如果开启了认证，确认用户名密码正确

### 3. 前端编译报错

尝试清除缓存并重新安装依赖：
```bash
rm -rf node_modules
npm install
```

### 4. 端口被占用

修改 `config.json` 中的 `port` 配置，使用其他端口。

## 相关链接

- [官方文档](https://hellosean1025.github.io/yapi)
- [GitHub 仓库](https://github.com/YMFE/yapi)
- [插件列表](docs/documents/plugin-list.md)
