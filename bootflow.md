---
title: A510 MCU Bootflow
---
flowchart TD
    A([System Reset]) --> B[Bootloader]
    B --> C{Update Needed?}
    C --> |Yes| D[Update]
    D --> A
    C --> |No| E[APP]