# Markov Chen (make it more C-class)

I'm a system architect in AI research and development, advocating semiconductor innovation and robotics intelligence adopts sovereign AI.

ITRI AI Hub for sovereign AI Chips can be used in semiconductor innovation and robotics intelligence technilogy.

at ITRI, working across the semiconductor and mechatronic groups on heterogeneous integration for embedded AI and robotics controllers. That work splits into two SDKs I maintain here: an **Agentic SDK** for reasoning and planning systems, and an **Embodied SDK** for physical control systems.

## Agentic SDK

Since 2023, AI companies have been racing toward systems that approach AGI, and this SDK tracks the open-source models, chips, and agent harnesses I draw on for that work. The stack below separates model access, orchestration, memory, and function nodes into four independent layers.

```mermaid
---
title: Agentic SDK
---
packet
0-5: "Perceive"
6-11: "Plan"
12-17: "Retrieve"
18-23: "Act"
24-31: "Reflect"
32-47: "InContextMemory"
48-63: "Hierarchical Memory（MemGPT）"
64-79: "Workflow"
80-95: "Plan-Action"
96-127: "OpenAI SDK"
```

Bottom to top: the **model interface** layer standardizes how the workflow calls any model, so inference can run against a chosen endpoint without changing the layers above it. The **orchestration** layer owns execution state, decides the next step, and manages how a run advances or ends. The **memory** layer carries conversation context across turns and stores retrievable long-term experience. The **function-node** layer handles input understanding, next-step decisions, data retrieval, responses and tool actions, and checking results to re-plan. Keeping model connectivity, execution control, context retention, and agent behavior in separate layers means any one layer's strategy can be swapped without touching the others' responsibilities.

Reference hardware I target for this stack:

* [AMD Ryzen AI Series]()
* [NVIDIA Jetson Series]()
* [MediaTek Genio Series]()

## Embodied SDK

The physical-AI counterpart to the Agentic SDK — this is where planning decisions turn into motor commands under real energy, safety, and spatial constraints, covering everything from perception to actuation on real hardware.

```mermaid
---
title: Embodied SDK
---
packet
0-15: "Embodied SDK"
16-31: "Touch Web App"
32-42: "Map & Navigation Console"
43-52: "Test Playground"
53-63: "Smart Control Board"
64-73: "Mechanism Localization & Translation"
74-84: "Sim-to-Real Dynamics Calibration"
85-95: "Edge AI Inference Engine"
96-111: "Control Command Generator"
112-127: "Control Interface"
128-135: "Battery Management"
136-143: "Safety Net"
144-151: "SLAM"
152-159: "Task Planning"
160-166: "Hardware Abstraction"
167-173: "Motion Control"
174-180: "Shared Memory"
181-186: "Environment Sensing"
187-191: "AI Accelerator"
192-207: "Real-Time OS (RTOS)"
208-223: "General-Purpose OS (GTOS)"
224-255: "Cerebrum-Cerebellum Co-Control Platform"
```

Four layers split responsibility from operation down to execution. The **interface** layer lets developers and field operators create, observe, and run tasks. The **core tools** layer provides shared positioning, calibration, and edge-compute capabilities that everything above draws on. The **domain application** layer turns operational intent into control decisions, constrained by energy, safety, spatial state, and mission goals. The **infrastructure** layer provides device access, real-time execution, sensing, and compute so the upper layers can run on physical hardware. Each layer keeps to its own boundary — the interface layer doesn't make domain decisions, core tools doesn't set mission goals, the domain layer doesn't implement hardware drivers, and infrastructure doesn't own user workflows. Data formats between modules, call order, the technology stack, hardware protocols, and benchmark targets are still open, pending industry comparison and finalized module specs.

## About This Account

This account collects my work on software development, system design, and technical documentation — currently centered on software architecture and maintainability, workflow automation, and using clear documentation to support team collaboration. Selected projects and technical notes will be added to public repositories here over time.
