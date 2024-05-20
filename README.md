## Transformador BitNet 1.58b en VeriLog

**Descripción General**

Este proyecto Verilog HDL implementa un módulo de multiplicación ternaria vectorial, diseñado para replicar la operación fundamental de una capa transformador en el estilo utilizado en el modelo de lenguaje LLAMA. El objetivo principal es seguir los patrones de diseño descritos en el artículo "The Era of 1-bit LLMs: All Large Language Models are in 1.58 Bits". La arquitectura se dejará de trabajar en icarus verilog y se trabajará en Verilator para poder simular un diseño de esta escala.

**Arquitectura Actual**

La arquitectura cambió a utilizar un solo sumador para procesar todas las listas a sumar en el producto ternario, pues los requerimientos en memoria eran imposibles para un diseño totalmente paralelo (al menos hasta donde se probó con iVerilog).

**Objetivos a Largo Plazo**

El objetivo final de este proyecto es sintetizar una capa transformador completa utilizando el módulo de multiplicación ternaria vectorial optimizado. Esto permitiría explorar la viabilidad de implementar modelos de lenguaje de gran tamaño (LLM) con un consumo de recursos computacionales significativamente menor.

**Próximos Pasos**

* Se llevará a cabo una reestructuración del código para ser compatible con Verilator.
* Se sintetizará una capa transformador completa utilizando el módulo de multiplicación ternaria vectorial optimizado (usando este módulo hasta cinco veces).
* Se diseñarán los módulos necesarios para la codificación espacial, las funciones de activación y la normalización.

**Referencias**

* "The Era of 1-bit LLMs: All Large Language Models are in 1.58 Bits" ([https://papers.cool/arxiv/2402.17764](https://papers.cool/arxiv/2402.17764))
