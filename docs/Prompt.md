# Role: AI Agent Skill 架构专家 & 交付方法论专家

# Task: 开发并输出一套名为 [Master_Plan_Architect_Skill] 的 AI Agent Skill。

# Input Data Source:
- 参考文档：@DELIVERY_METHODOLOGY.md (包含 Phase 1-7, Key Activities, Key Work Flows, Checklists)
- 动态输入：客户的业务需求与技术要求。

# 目标 Skill 执行逻辑 (你生成的 Skill 必须包含以下功能)：
1. **阶段匹配逻辑**：解析客户需求，从方法论的 Phase 1-7 中提取适配的阶段。
2. **任务原子化**：将 "Key Activities" 转化为具体的 Agent 任务节点。
3. **依赖编排 (DAG)**：根据 "Key Work Flows" 建立任务间的逻辑先后关系，禁止循环依赖。
4. **工具指派**：为每个任务节点分配一个“真实存在”的 AI Agent Skill（如：需求分析 Skill、架构设计 Skill、代码生成 Skill）。
5. **任务输出**： 根据 “Check List of Deliverables" 的内容，为每个任务节点制定输出清单
6.  **自动化质量门禁 (Stage-Gate)**：将 "Check List of Deliverables" 转化为 AI Reviewer 的判定准则。
# 生成要求 (请输出以下格式的内容)：

## 1. Skill 系统提示词 (System Instructions)·
- 定义该 Agent 如何解析需求。
- 定义如何引用方法论中的专业术语。
- 定义如何将任务映射到现有的 Agent 工具链。

## 2. 交互式执行流 (Workflow)
- **第一步**：收集客户需求。
- **第二步**：产出【人机双语 Master Plan】。
    - **人读版**：Markdown 表格（包含：序号、阶段、任务名称、前置依赖 ID、执行 Skill、DoD 验收标准）。
    - **机读版**：JSON 格式的 DAG 任务图（包含：nodeID, dependencies, skill_call_endpoint）。
- **第三步**：启动自动审批循环。调用 Reviewer Skill 对每个阶段的 Deliverables 进行合规性检查。

## 3. 上下文恢复机制 (Anchor Mechanism)
- 生成一个 `Sprint0_Skill_Context.md` 的模板定义，用于在对话中断后快速恢复所有 Phase 的执行进度和任务状态。

## 4. 自动化审批逻辑定义
- 详细说明 AI 如何根据方法论中的 Check List 进行“不通过->反馈->重做”的闭环操作。