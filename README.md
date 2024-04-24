## Transformador BitNet 1.58b en VeriLog

**Descripción General**

Este proyecto Verilog HDL implementa un módulo de multiplicación ternaria vectorial, diseñado para replicar la operación fundamental de una capa transformador en el estilo utilizado en el modelo de lenguaje LLAMA. El objetivo principal es seguir los patrones de diseño descritos en el artículo "The Era of 1-bit LLMs: All Large Language Models are in 1.58 Bits".

**Arquitectura Actual**

La arquitectura actual del módulo se caracteriza por un alto grado de paralelización, empleando múltiples instancias de árboles sumadores para procesar los datos de manera eficiente. Sin embargo, este enfoque presenta un inconveniente en términos de recursos computacionales, ya que consume una gran cantidad de unidades lógicas programables (FPGA) debido a la proliferación de árboles sumadores.

**Optimización Recomendada**

Se recomienda rediseñar la arquitectura del módulo para reducir la cantidad de árboles sumadores utilizados. Esto se puede lograr mediante técnicas de optimización como la reorganización del flujo de datos y la implementación de algoritmos más eficientes para la suma de vectores.

**Objetivos a Largo Plazo**

El objetivo final de este proyecto es sintetizar una capa transformador completa utilizando el módulo de multiplicación ternaria vectorial optimizado. Esto permitiría explorar la viabilidad de implementar modelos de lenguaje de gran tamaño (LLM) con un consumo de recursos computacionales significativamente menor.

**Consideraciones Adicionales**

* El módulo actual está diseñado para manejar vectores de datos de gran tamaño, lo que lo hace adecuado para su uso en aplicaciones de procesamiento de lenguaje natural a gran escala.
* La arquitectura paralelizada ofrece un alto rendimiento, pero requiere una optimización cuidadosa para minimizar el consumo de recursos computacionales.
* La implementación en Verilog HDL permite la síntesis del módulo en FPGAs, posibilitando la aceleración de hardware de la multiplicación ternaria vectorial.

**Próximos Pasos**

* Se llevará a cabo una reestructuración de la arquitectura del módulo para reducir la cantidad de árboles sumadores utilizados, usando 16 veces menos árboles que el diseño actual (mi computador no puede compilar diseños tan grandes).
* Se sintetizará una capa transformador completa utilizando el módulo de multiplicación ternaria vectorial optimizado (usando este módulo hasta cinco veces).
* Se diseñarán los módulos necesarios para la codificación espacial, las funciones de activación y la normalización.

**Referencias**

* "The Era of 1-bit LLMs: All Large Language Models are in 1.58 Bits" ([https://papers.cool/arxiv/2402.17764](https://papers.cool/arxiv/2402.17764))
