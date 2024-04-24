## Módulo de Transformador 1.58 bits para LLMs de baja precisión en Verilog

**Introducción**

El presente documento describe las especificaciones detalladas del módulo de transformación 1.58 bits para la implementación de Modelos de Lenguaje a Gran Escala (LLMs) de baja precisión en hardware de baja potencia. El módulo se basa en la arquitectura BitNet b1.58, propuesta en el paper [[The Era of 1-bit LLMs All Large Language Models are in 1.58 Bits.pdf]], adaptándola para su implementación en Verilog.

**Objetivo**

El objetivo principal del módulo de [[Transformador]] 1.58 bits es proporcionar una implementación eficiente y compacta de la capa de transformación en LLMs de baja precisión, aprovechando las ventajas de la cuantización de pesos y activaciones a 1.58 bits.

**Arquitectura**

La arquitectura del módulo de transformación 1.58 bits se compone de los siguientes bloques funcionales:

- **Unidad de Multiplicación Matriz-Vector (MMU):** Realiza la multiplicación ternaria entre los pesos de 1.58 bits y las activaciones de entrada de 8 bits.
- **Unidad de Activación (AU):** Aplica la función de activación SwiGLU a las activaciones intermedias.
- **Unidad de Normalización (NU):** Aplica la normalización RMSNorm a las activaciones post-activación.

**Especificaciones detalladas**

**Unidad de Multiplicación Matriz-Vector (MMU)**

- **Función:** Multiplica los pesos ternarios (-1, 0, 1) por las activaciones de entrada de 8 bits.
- **Optimizaciones:**
    - Soporte para operaciones vectoriales para procesar múltiples elementos simultáneamente.
    - Uso de técnicas de reducción de redundancia de datos para minimizar el ancho de banda de memoria.
    - Implementación de algoritmos de multiplicación eficientes para operaciones ternarias.

**Unidad de Activación (AU)**

- **Función:** Aplica la función de activación SwiGLU (Scaled Weighted Linear Units).
- **Ecuación:** `y = a * x + b * step(x)`
    - `y` es la salida de la AU.
    - `x` es la entrada a la AU.
    - `a` es el parámetro de escala.
    - `b` es el parámetro de desplazamiento.
    - `step(x)` es la función de activación escalonada.

**Unidad de Normalización (NU)**

- **Función:** Normaliza las activaciones utilizando la normalización RMSNorm.
- **Pasos:**
    1. Calcular la media de las activaciones de entrada.
    2. Calcular la desviación estándar de las activaciones de entrada.
    3. Normalizar cada activación de entrada por la raíz cuadrada de la media cuadrática calculada en el paso 2.

**Interfaces**

- **Entrada:** Activaciones de entrada de 8 bits provenientes de la capa anterior.
- **Salida:** Activaciones de salida de 8 bits para la siguiente capa.
- **Configuración:** Parámetros de la capa, como dimensiones de pesos y activaciones.

**Precisión**

- **Activaciones:** 8 bits de precisión fija.
- **Pesos:** Precisión ternaria (-1, 0, 1).

**Consideraciones adicionales**

- **Escalabilidad:** La arquitectura debe ser escalable para admitir capas de diferentes tamaños y dimensiones.
- **Consumo de energía:** Se debe evaluar el consumo de energía de la implementación y optimizarla para mejorar la eficiencia.
- **Comparación con otras implementaciones:** Se debe comparar el rendimiento y la eficiencia de la capa con otras implementaciones de hardware y software de capas de LLMs de baja precisión.

