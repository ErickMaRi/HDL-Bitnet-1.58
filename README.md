## Transformador BitNet 1.58b en VeriLog

**Descripción General**

Este proyecto Verilog HDL busca implementar una capa de transformador siguiendo la arquitectura usada en LLAMA 2 para un modelo cuantizado a dos bits para la matriz de pesos (-1, 0 , 1) y un vector de 4096 activaciones de ocho bits con signo. Para implementar este diseño se busca trabajar dentro de los márgenes de lo sintetizable y bitstreameable a FPGA para efectivamente tener un acelerador para la inferencia únicamente (los pesos del modelo se toman como dados).

**Arquitectura Actual**

Actualmente el diseño descrito en Verilog presenta una guía conceptual que servirá para optimizar el diseño a un floorplan decente. Se usa un árbol de sumadores (de doce capas) para coordinar la suma de todos los vectores de activación, habiendo sido ya multiplicados por la matriz de pesos. Hasta el momento lo implementado es la multiplicación ternaria.

**Arquitectura a desarrollar**

Con el fin de optimizar para un floorplan hacible es necesario cambiar fundamentalmente la estrategia tomada para implementar el módulo, con este fin es necesario cambiar la manera en la que se comunica la información, alambrando muchos menos puertos entre sí, para fines de poder simular y verificar en una laptop además de presentar un diseño menos sobreingeniado.

*Multiplicación ternaria:*
Se le llama activación al vector de entradas de ocho bits, pesos a la matriz de entradas de dos bits y escalares a cada una de las salidas del producto ternario.

Para efectivamente comunicar los componentes del módulo dedicado a la multiplicación  **Matriz** * **Vector**, considerando los tamaños de vector con los que lidiamos (4096) y la redundancia de calcular independientemente el producto de los pesos por las activaciones (ya que sabemos que los pesos son sólo tres).

Utilizaremos un protocolo basado en SPI para comunicar la primera activación sin modificar a todos los escalares cuyo peso asociado sea 1, -1*activación a todos los escalares cuyo peso asociado sea -1 y finalmente no vamos a tomar acción para cada uno de los escalares cuyo peso asociado era cero. En cada uno de estos escalares tendremos un registro de 20 bits que suma el nuevo valor de entrada (en un registro de entradas de ocho bits), sin requerir el árbol de sumadores tan engorroso que usamos hasta ahora.
Lo anterior implica que nuestro controlador tendría 4096 puertos de un bit para el Chip Select, un puerto de un bit para el COPI conectado a todos los periféricos y carecerá de POCI pues no hay un control realimentado (el progreso del diseño nos permitirá discernir si es necesario usar menos puertos para el Chip Select y un deMUX coordinado por nuestro controlador para alimentar los nuevos valores de entrada 32, 64 o 256 valores a la vez).

Es importante implementar el módulo de forma parametrizada, de manera en la que las dimensiones de la matriz/vector sean ajustables, con el fin de serializar varias de estas operaciones y calcular las proyecciones del vector de embeddings para los Queries, Keys y Values (obtenidos de un producto **Q** = **X** * **W_Q**, por ejemplo).

Siguiendo un principio de memoria on edge, es necesario tener dos bancos de memorias, uno para las activaciones y otro para los pesos, controlado por un módulo que coordina la lectura y escritura de los valores, siendo este controlador accesado por un puerto que se comunica con protocolo I2C o SPI al mundo exterior. El controlador tiene la capacidad de seleccionar la entrada ya sea para la escritura en la memoria o para presentar los datos a la lectura del maestro de los escalares.

*Función de activación:*

  Se implementará ReLU por simpleza pero la función que se va a usar es SwiGLU, con una entrada de 20 bits y una salida de ocho bits, ambos con signo.

*Módulo de Atención Multi-Cabeza (Multi-Head Attention):*

  Implementar el cálculo completo de la atención multi-cabeza, que incluye:

    - Cálculo de las puntuaciones de atención
    - Aplicación de la función softmax
    - Combinación ponderada de los valores
    - División por la raíz cuadrada de la dimensión de las claves
    - Concatenación de las salidas de las diferentes cabezas de atención

*Normalización de Capas (Layer Normalization):*

    - Implementar un módulo que calcule la media y la varianza a lo largo de dimensiones específicas
    - Normalizar las entradas en base a la media y varianza calculadas

*Conexiones Residuales (Residual Connections):*

    - Implementar la suma de las entradas con las salidas de la atención multi-cabeza
    - Implementar la suma de las entradas con las salidas de la red neuronal feed-forward

**Referencias**

* "The Era of 1-bit LLMs: All Large Language Models are in 1.58 Bits" ([https://papers.cool/arxiv/2402.17764](https://papers.cool/arxiv/2402.17764))
* "Llama 2: Open Foundation and Fine-Tuned Chat Models" ([https://arxiv.org/pdf/2307.09288](https://arxiv.org/pdf/2307.09288))
