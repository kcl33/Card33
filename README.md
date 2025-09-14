# CardForge Nexus

一个类似游戏王和影之诗的桌面卡牌游戏原型，使用Godot引擎开发。

## 项目概述

CardForge Nexus是一款结合了游戏王和影之诗元素的单机roguelike卡牌游戏。游戏具有费用机制、明确的卡牌分类、前后场区域、墓地卡组、额外卡组等元素。

## 核心功能

- 回合制卡牌战斗系统
- 多种召唤方式（通常召唤、上级召唤、特殊召唤、额外召唤）
- 完整的战斗机制（怪兽间战斗和直接攻击）
- 卡牌效果系统
- 费用点数和额外点数资源管理系统
- Roguelike元素（待完善）
- 遗物系统
- 组件化卡牌系统（类似炉石传说的模块化机制）

## 技术特性

- 使用Godot 4开发
- 模块化的代码结构
- 可扩展的卡牌系统
- 可复用的战斗和召唤系统
- 集成专业Card Framework插件
- 曲线控制的手牌扇形布局
- 流畅的抽卡动画效果

## 当前实现

### 已完成
- 玩家属性系统（生命值、费用、额外点数等）
- 回合流程控制
- 召唤系统（四种召唤方式）
- 战斗系统（怪兽战斗和直接攻击）
- 场地管理系统（前场、后场、额外区域）
- 卡牌效果系统（基础版本）
- 测试场景和主菜单
- 扇形手牌UI系统
- 场地可视化系统
- 抽卡动画系统
- 遗物系统（基础框架和示例）
- 组件化卡牌系统（可组装机制）
- 专业级Card Framework插件集成

### 待实现
- 完整的Roguelike元素（肉鸽机制、卡包系统）
- 角色技能系统
- 完整的UI界面
- 音效和音乐系统
- 更多卡牌效果和机制
- 多人对战功能

## 项目结构

```
res://
├── scripts/
│   ├── core/           # 核心系统（玩家、卡牌、场地等）
│   ├── battle/         # 战斗系统（战斗管理器等）
│   └── ui/             # 用户界面（手牌区域、场地可视化等）
├── scenes/
│   ├── battle/         # 战斗场景
│   └── ui/             # 界面场景
├── cards/              # JSON格式的卡牌数据
├── assets/             # 游戏资源（图像、音频等）
└── addons/             # 插件目录（包含专业Card Framework）
```

## 核心组件

### 卡牌系统
- [Card.gd](file://d:\Second\sen\scripts\core\Card.gd) - 基础卡牌类，支持多种类型（怪兽、法术、组件等）
- [ForgeCardExamples.gd](file://d:\Second\sen\scripts\core\ForgeCardExamples.gd) - 示例卡牌生成器
- 组件化机制 - 支持给怪兽卡安装组件以增强能力

### 玩家系统
- [Player.gd](file://d:\Second\sen\scripts\core\Player.gd) - 玩家类，管理生命值、费用、手牌等
- [Field.gd](file://d:\Second\sen\scripts\core\Field.gd) - 场地管理系统
- 遗物系统 - 通过[BurningBloodRelic.gd](file://d:\Second\sen\scripts\core\BurningBloodRelic.gd)等实现

### 战斗系统
- [BattleManager.gd](file://d:\Second\sen\scripts\battle\BattleManager.gd) - 战斗管理器
- [SummonSystem.gd](file://d:\Second\sen\scripts\core\SummonSystem.gd) - 召唤系统（支持多种召唤方式）

### UI系统
- [HandArea.gd](file://d:\Second\sen\scripts\ui\HandArea.gd) 和 [AdvancedHandArea.gd](file://d:\Second\sen\scripts\ui\AdvancedHandArea.gd) - 手牌显示系统
- [FieldVisual.gd](file://d:\Second\sen\scripts\ui\FieldVisual.gd) - 场地可视化
- [DrawCardAnimation.gd](file://d:\Second\sen\scripts\ui\DrawCardAnimation.gd) - 抽卡动画

### 插件系统
- 集成[chun92/card-framework](https://github.com/chun92/card-framework)专业卡牌框架
- 支持JSON格式卡牌数据定义
- 提供拖放、容器管理等专业功能

## 如何运行

1. 下载并安装Godot 4
2. 克隆或下载此项目
3. 在Godot中打开项目
4. 运行项目

## 开发路线图

1. 完善Roguelike元素（肉鸽机制、卡包系统）
2. 实现角色技能系统
3. 设计完整的UI界面
4. 添加音效和音乐系统
5. 开发更多卡牌效果和机制
6. 实现多人对战功能

## 许可证

请查看LICENSE文件了解详细信息。