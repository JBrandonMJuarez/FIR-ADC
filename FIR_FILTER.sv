module FIR_FILTER
#(
    parameter ADDR_WIDTH = 8,      // Ancho de la dirección, 256 coeficientes = 2^8
    parameter COEF_COUNT = 256     // Número total de coeficientes
)
(
    input                       clk_in,         // Reloj
    input                       rst_in,         // Reset asíncrono
    input                       next_in,        // Control de desplazamiento de muestras
    input       [11:0]          x_in,           // Entrada de datos (12 bits)
    output reg  [11:0]          y_out           // Salida de datos (12 bits)
);

    // Memoria para los coeficientes
    reg signed [15:0] coef_mem [0:COEF_COUNT-1]; // Coeficientes de 16 bits (signed)
    initial $readmemh("coefis0.txt", coef_mem);  // Inicialización desde archivo

    // Memoria para las muestras de entrada
    reg signed [11:0] x_mem [0:COEF_COUNT-1];

    // Acumulador para el cálculo
    reg signed [28:0] acum;  // Suficientemente grande para evitar desbordamiento

    // Desplazamiento de las muestras de entrada controlado por `next_in`
    integer i;
    always @(posedge clk_in or negedge rst_in) begin
        if (!rst_in) begin
            for (i = 0; i < COEF_COUNT; i = i + 1) begin
                x_mem[i] <= 12'b0;
            end
        end else if (next_in) begin
            x_mem[0] <= x_in;  // La nueva muestra entra al primer registro
            for (i = 1; i < COEF_COUNT; i = i + 1) begin
                x_mem[i] <= x_mem[i-1];  // Desplazamiento
            end
        end
    end

    // Cálculo del FIR con acumulador único
    always @(posedge clk_in or negedge rst_in) begin
        if (!rst_in) begin
            acum <= 0;
            y_out <= 0;
        end else if (next_in) begin
            acum <= 0;  // Limpia el acumulador antes del cálculo
            for (i = 0; i < COEF_COUNT; i = i + 1) begin
                acum <= acum + x_mem[i] * coef_mem[i];  // Producto acumulativo
            end
            // Saturación y conversión a 12 bits
				y_out <= (acum/20'd100000) + 12'd2047;
//            if (acum > 12'hFFF) begin
//                y_out <= 12'hFFF;  // Clipping superior
//            end else if (acum < 12'h000) begin
//                y_out <= 12'h000;  // Clipping inferior
//            end else begin
//                y_out <= acum[28:17];  // Reducción de bits (12 MSB)
//            end
        end
    end

endmodule
