# 重构说明

## 目录结构变更

为了更好地组织项目文件，我们对目录结构进行了重构，将原先分散在 [scripts/](file:///D:/Second/sen/scripts/core/Field.gd) 目录下的文件移动到更加清晰的 [game/](file:///D:/Second/sen/game/scenes/TestBattle.tscn) 目录结构中。

### 变更详情

1. **实体类移动**
   - [Card.gd](file:///D:/Second/sen/game/entities/Card.gd) 和 [Player.gd](file:///D:/Second/sen/game/entities/Player.gd) 移动到 [game/entities/](file:///D:/Second/sen/game/entities/)
   - 遗物相关类移动到 [game/entities/relics/](file:///D:/Second/sen/game/entities/relics/)
   - 组件相关类移动到 [game/entities/components/](file:///D:/Second/sen/game/entities/components/)

2. **系统类移动**
   - 核心系统类移动到 [game/systems/](file:///D:/Second/sen/game/systems/)
   - 战斗相关系统类移动到 [game/systems/battle/](file:///D:/Second/sen/game/systems/battle/)

3. **UI类移动**
   - 所有UI相关类移动到 [game/ui/](file:///D:/Second/sen/game/ui/)

4. **场景文件移动**
   - 场景文件移动到 [game/scenes/](file:///D:/Second/sen/game/scenes/) 及其子目录

### 下一步计划

1. 更新所有引用这些文件的代码，使其适应新的路径
2. 清理空的 [scripts/](file:///D:/Second/sen/scripts/core/Field.gd) 目录
3. 更新项目文档以反映新的结构

### 注意事项

由于文件路径变更，所有引用这些文件的代码都需要更新。特别是使用 `preload()` 的地方，需要修改为新的路径或使用 `class_name` 系统。

### 已修复的问题

1. **重复变量定义**：修复了 [Player.gd](file:///D:/Second/sen/game/entities/Player.gd) 中的重复变量定义问题
2. **错误的文件引用路径**：修复了多个文件中引用旧路径的问题，改为直接使用类名
3. **继承路径问题**：修复了 [BurningBloodRelic.gd](file:///D:/Second/sen/game/entities/relics/BurningBloodRelic.gd) 中的继承路径问题
4. **类引用问题**：修复了 [TestBattle.gd](file:///D:/Second/sen/game/systems/battle/TestBattle.gd) 和其他文件中的类引用问题

这些修改解决了因重构引起的"Parse error"问题。