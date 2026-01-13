# Tech Spec v0.1（本地优先 / 无Auth）

- 项目：个人成长系统（Personal Growth System）
- 版本：v0.1
- 文档状态：Draft
- 最后更新：2026-01-13
- 平台：Flutter Desktop（macOS / Windows）

---

## 0. 本文档目的

把 PRD v0.1 的“做什么”落到“怎么做、怎么拆、怎么验收”，并给编码大模型/协作开发提供一致的工程约束与接口边界。

---

## 1. 范围与约束

### 1.1 v0.1 范围（必须交付）

- Today：记录入口（心情/精力/压力可选 + 标签 + 习惯/数据点快速记录）
- Buckets：特质水桶可视化（0~100 水位、今日Δ、7/30天趋势、详情页贡献来源）
- Review：7/30天复盘（Top/Bottom days + 简单“可能相关因素”提示）
- Local-first：本地数据库持久化 + 导出备份（JSON）

### 1.2 v0.1 不做

- Auth/账号体系、云同步、多端冲突处理
- 社交分享、排行榜、复杂AI建议
- 复杂第三方数据接入

---

## 2. 技术栈与工具（Tooling）

### 2.1 语言与框架

- 编程语言：Dart
- UI框架：Flutter（Desktop：macOS/Windows）

### 2.2 状态管理与依赖注入

- Riverpod（统一全项目状态管理与依赖注入入口）

### 2.3 本地存储

- SQLite
- Drift（Dart/Flutter 的响应式持久化库，负责 schema / migration / typed queries）

### 2.4 工程与协作

- Git + GitHub（PR 流程）
- 脚本：
  - `tool/run_macos.sh`
  - `tool/run_windows.ps1`
- `.gitignore`：忽略生成物与临时目录（已补齐）

> 说明：Supabase（URL/ANON_KEY）暂时仅保留环境变量与脚本入口，v0.1 不依赖云端；后续 v0.2+ 再引入同步与RLS。

---

## 3. 架构原则（分层 + 按功能切片）

目标：避免 UI 里直接写“业务规则/数据库/计算逻辑”，保证可维护、可测试。

### 3.1 分层定义

- presentation：Widget/UI，负责展示与交互事件
- application：用例层（UseCases），编排流程（保存记录、计算水桶、写快照）
- domain：纯业务模型与规则接口（Bucket/Rule/Insight），不依赖 Flutter/Drift
- data：数据库/DAO/Repository 实现，负责持久化与数据映射

### 3.2 依赖方向（单向）

presentation → application → domain
presentation → (read-only) domain models
data → domain（实现 domain 的 repository 接口）
application 通过 domain 接口使用 data（由 Riverpod 注入实现）

---

## 4. 目录结构（建议）

```text
lib/
  app/
    app.dart                  # MaterialApp / Router / Theme
    app_shell.dart            # 顶层导航：Today/Buckets/Review/Settings
  shared/
    db/
      app_database.dart       # Drift Database
      migrations.dart
    time/
      date_utils.dart
    ui/
      widgets/                # 通用组件（空状态、loading、chips等）
      theme/
  features/
    today/
      presentation/
      application/
      domain/
      data/
    buckets/
      presentation/
      application/
      domain/
      data/
    review/
      presentation/
      application/
      domain/
      data/
    settings/
      presentation/
      application/
      domain/
      data/
docs/
  prd/prd_v0.1.md
  tech/tech_spec_v0.1.md
tool/
  run_macos.sh
  run_windows.ps1
````

---

## 5. 数据模型（Drift / SQLite）

### 5.1 核心概念

- DayLog：某天的主观评分与备注
- Tag：标签（奶茶/熬夜/健身…）
- Habit：习惯（勾选/计数/时长）
- HabitEntry：某天某习惯的记录
- Bucket：特质维度（水桶）
- BucketRule：把“记录”映射为水位变化的规则
- BucketSnapshot：每天每个水桶的水位与Δ（可回放）

### 5.2 表结构（v0.1）

> 字段名可按 Drift 习惯（snake_case）或 dartCase；统一即可。

- day_log

  - date (TEXT, PK, YYYY-MM-DD)
  - mood_score (INT, nullable, 1-5)
  - energy_score (INT, nullable, 1-5)
  - stress_score (INT, nullable, 1-5)
  - note (TEXT, nullable)
  - created_at, updated_at

- tag

  - id (TEXT, PK UUID)
  - name (TEXT, unique)
  - color (INT, nullable)
  - created_at

- day_tag

  - date (TEXT, FK day_log.date)
  - tag_id (TEXT, FK tag.id)
  - PK(date, tag_id)

- habit

  - id (TEXT, PK UUID)
  - name (TEXT)
  - type (TEXT enum: check/count/duration)
  - is_active (BOOL)
  - created_at

- habit_entry

  - date (TEXT)
  - habit_id (TEXT)
  - value (INT)  # check: 0/1; count: 次数; duration: 分钟
  - updated_at
  - PK(date, habit_id)

- bucket

  - id (TEXT, PK UUID)
  - name (TEXT)
  - min_level (INT default 0)
  - max_level (INT default 100)
  - sort_order (INT)
  - created_at

- bucket_rule

  - id (TEXT, PK UUID)
  - bucket_id (TEXT, FK bucket.id)
  - source_type (TEXT enum: habit/tag/score/datapoint)
  - source_key (TEXT)  # habit_id / tag_id / score_name("mood") / datapoint_id
  - weight (REAL)      # +/-
  - mapping_json (TEXT, nullable) # 规则参数（如评分映射、阈值等）
  - is_active (BOOL)

- bucket_snapshot

  - date (TEXT)
  - bucket_id (TEXT)
  - level (INT 0-100)
  - delta (INT)
  - computed_at
  - PK(date, bucket_id)

### 5.3 迁移策略（v0.1）

- Drift migrations：每次 schema 变更必须写 migration
- v0.1 允许“开发期破坏性迁移”但必须可导出/导入数据（避免数据丢失恐惧）
- release 前冻结 schema + 严格迁移

### 5.4 导出备份（JSON）

- `Settings -> Export` 生成：`userdata_YYYYMMDD_HHMM.json`
- 内容：所有表的记录（或至少 day_log/day_tag/habit/habit_entry/bucket/bucket_rule/bucket_snapshot）
- v0.1 导入策略：先做“覆盖导入”，后续再做合并策略

---

## 6. 业务规则：水桶引擎（Bucket Engine）

### 6.1 目标

- 输入：某天的记录（评分/标签/习惯/数据点）
- 输出：

  - 每个 bucket 的当日 delta
  - 当日 level（= 昨日level + delta，经 clamp/衰减/上限处理）
  - 写入 bucket_snapshot

### 6.2 计算约定（v0.1 简化版）

- level 范围：0~100，最终 clamp
- delta = Σ(rule_contribution)
- rule_contribution 基本形态：

  - habit：完成(1) *weight 或 value* weight
  - tag：出现(1) * weight
  - score：按 mapping 将 1-5 映射到 [-k, +k] 再乘 weight
- 可选（v0.1 先不开）：衰减（如每日 -1）用于“长期不维持会下降”

### 6.3 伪代码

```text
computeForDate(date):
  inputs = loadDayInputs(date)  # day_log + day_tag + habit_entry + (datapoint later)
  rules = loadActiveRules()

  for bucket in buckets:
    delta = 0
    for rule in rules where rule.bucket_id == bucket.id:
      delta += applyRule(rule, inputs)

    prevLevel = loadSnapshot(date-1, bucket)?.level ?? defaultLevel(bucket)
    level = clamp(prevLevel + round(delta), 0, 100)
    writeSnapshot(date, bucket.id, level, round(delta))
```

### 6.4 可解释性（必须）

Bucket 详情页要能展示“贡献清单”：

- 今天哪些 rule 生效了
- 每条贡献值是多少
- 样本/依据来自哪条记录（habit/tag/score）

实现建议：

- 计算时同时产出 `Contribution[]`（内存）用于详情页展示（v0.1 可不入库；后续可持久化）

---

## 7. 洞察（Insights）— v0.1 只做“可能相关”

### 7.1 原则

- 只显示相关性，不下因果结论
- 必须显示样本数 n
- n < 7：提示“数据不足”

### 7.2 v0.1 可实现的提示

- 标签 vs 评分：有/无某标签时 mood/energy 的均值差
- 习惯 vs 水桶：完成/未完成时 bucket_delta 的均值差
- 高/低水位日共现：Top3/Bottom3 day 的常见标签/习惯

---

## 8. 状态管理与数据流（Riverpod + Drift）

### 8.1 Provider 约定

- `databaseProvider`：提供 AppDatabase（单例）
- `repoProviders`：各 feature 的 repository（由 databaseProvider 构造）
- `useCaseProviders`：用例层对象
- `uiStateProviders`：页面状态（筛选、选中日期等）

### 8.2 响应式刷新

- 列表/趋势尽量用 Drift `.watch()` 输出 Stream
- UI 端通过 Riverpod 的 StreamProvider/Provider 订阅并自动刷新

---

## 9. 页面与交互（v0.1）

### 9.1 Today

- 组件：评分（1-5）、标签 chips、习惯列表（勾选/计数/时长）
- 操作：保存后触发 `SaveTodayLogUseCase`：

  1. upsert day_log/day_tag/habit_entry
  2. 触发计算 bucket snapshots（同一天）
  3. 返回成功/错误 toast

### 9.2 Buckets

- 列表：水桶卡片（名称、水位、水面动画、今日Δ、7天 mini sparkline）
- 详情：30天曲线 + 今日贡献来源（Contribution list）

### 9.3 Review

- 7/30天：每桶趋势
- Top/Bottom days：当天记录摘要 + “可能相关因素”提示

### 9.4 Settings

- 水桶管理：新增/排序
- 规则管理：绑定 habit/tag/score → 某 bucket，调整 weight
- 导出备份：JSON

---

## 10. 运行与环境配置

### 10.1 环境变量（v0.1 可选）

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`

> v0.1 不依赖云端，但脚本保留入口用于后续扩展。

### 10.2 一键运行

- macOS：`./tool/run_macos.sh`
- Windows：`.\tool\run_windows.ps1`

---

## 11. 测试策略（v0.1 最小集合）

- domain：bucket engine 规则计算单测（纯 Dart，无 Flutter）
- application：保存流程的集成测试（使用临时数据库）
- presentation：关键页面 smoke test（能启动、能渲染、能保存）

---

## 12. 验收标准（Definition of Done）

- 任意一天新增/修改记录后：

  - bucket_snapshot 当天数据会更新
  - Buckets 页面水位即时变化（无需重启）
- 关闭 app 再打开：数据完整
- 导出 JSON 可成功生成文件
- macOS/Windows 均可一键运行（脚本可用）
- 代码遵守分层边界：UI 不直接写 SQL/计算规则

---

## 13. 里程碑（建议）

- M0（1-2天）：Drift 建库 + Today 最小保存 + Buckets 空壳
- M1（3-5天）：Bucket Engine + Buckets 列表/详情 + 水位动画
- M2（3-5天）：Review + Insights（n门槛）+ Export

```

参考资料（用于本 Tech Spec 的技术选型与原则依据）：
- Flutter 官方架构建议（分离 UI 层与数据层、按职责拆分）：:contentReference[oaicite:0]{index=0}  
- Flutter 状态管理基础概念：:contentReference[oaicite:1]{index=1}  
- Riverpod 官方文档（状态管理/依赖注入）：:contentReference[oaicite:2]{index=2}  
- Drift 官方文档（响应式持久化、schema/migrations）：:contentReference[oaicite:3]{index=3}  
- Supabase Flutter 文档（后续如需接入云端/同步）：:contentReference[oaicite:4]{index=4}
::contentReference[oaicite:5]{index=5}
```
