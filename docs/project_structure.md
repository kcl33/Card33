# 项目结构说明

为了更好地组织项目文件，我们采用以下结构：

## 根目录
```
/
├── addons/              # Godot插件
├── assets/              # 游戏资源（图像、音频等）
├── cards/               # 卡牌定义文件
├── docs/                # 文档
├── game/                # 主游戏代码和场景
│   ├── entities/        # 游戏实体类（卡牌、玩家等）
│   │   ├── components/  # 组件相关实体
│   │   └── relics/      # 遗物相关实体
│   ├── systems/         # 核心系统（战斗系统、回合系统等）
│   │   └── battle/      # 战斗子系统
│   ├── managers/        # 管理器类（遗物管理器、效果管理器等）
│   ├── ui/              # UI相关脚本
│   ├── scenes/          # 场景文件
│   └── resources/       # 游戏资源文件
├── scripts/             # 其他脚本文件（已计划重构到game目录）
└── scenes/              # 其他场景文件（已计划重构到game/scenes）
```

## 详细说明

### 核心概念

1. **Entities（实体）**
   - [Card.gd](file:///D:/Second/sen/game/entities/Card.gd) - 卡牌基类
   - [Player.gd](file:///D:/Second/sen/game/entities/Player.gd) - 玩家类
   - 怪物、法术等具体实体

2. **Components（组件）**
   - 组件系统相关类
   - 各种卡牌组件类型

3. **Systems（系统）**
   - [GameController.gd](file:///D:/Second/sen/game/entities/components/GameController.gd) - 游戏主控制器
   - [BattleSystem.gd](file:///D:/Second/sen/game/entities/components/BattleSystem.gd) - 战斗系统
   - [SummonSystem.gd](file:///D:/Second/sen/game/entities/components/SummonSystem.gd) - 召唤系统
   - 回合系统等

4. **Managers（管理器）**
   - [EffectManager.gd](file:///D:/Second/sen/game/entities/components/EffectManager.gd) - 效果管理器
   - [RelicManager.gd](file:///D:/Second/sen/game/entities/components/RelicManager.gd) - 遗物管理器
   - 其他管理类

5. **UI（用户界面）**
   - 所有UI相关脚本
   - 手牌区域、场上区域等界面组件

### 已完成的重构

以下文件已经从 [scripts/](file:///D:/Second/sen/scripts/core/Field.gd) 目录移动到新的 [game/](file:///D:/Second/sen/game/scenes/TestBattle.tscn) 结构中：

1. 实体类移动到 [game/entities/](file:///D:/Second/sen/game/entities/) 及其子目录
2. 系统类移动到 [game/systems/](file:///D:/Second/sen/game/systems/) 及其子目录
3. UI类移动到 [game/ui/](file:///D:/Second/sen/game/ui/)
4. 管理器类移动到 [game/managers/](file:///D:/Second/sen/game/managers/)

### 重构计划

剩余的 [scripts/](file:///D:/Second/sen/scripts/core/Field.gd) 和 [scenes/](file:///D:/Second/sen/scenes/battle/) 目录内容将逐步迁移到 [game/](file:///D:/Second/sen/game/scenes/TestBattle.tscn) 目录下对应的子目录中，以更好地组织代码。

这样可以更清晰地分离关注点，便于维护和扩展。