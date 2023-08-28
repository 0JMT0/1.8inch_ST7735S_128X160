module top_checkered (
    input  wire clk12,
    output wire spi1_cs0,
    output wire spi1_sclk,
    output wire spi1_mosi,
    output wire lcd_dc,
    output wire lcd_bl,
    output wire lcd_nrst
);
    //                     checkered      red   green      blue     red   green blue
    wire [15:0] pattern1 = x[4] ^ y[4] ? {5'd0, 6'b111111, 5'd0} : {5'd0, 6'd0, 5'b11111};
    wire [15:0] pattern2 = (x > 8'd80) ? {5'd0, 6'b111111, 5'd0} : {5'b11111, 6'd0, 5'd0};

    wire [15:0] color = (switch < 24'h5B8D80) ? pattern1 : pattern2;
    wire [ 7:0] x;
    wire [ 7:0] y;

    reg [23:0] switch;

    initial begin
        switch = 0;
    end

    always @(posedge clk12) switch = switch + 1 ;

    // wire [15:0] color = {5'b0, 6'b111111, 5'b11111};
    assign lcd_bl = 0;

    st7735  driver (
        .clk(clk12),
        .x(x),
        .y(y),
        .color(color),
        // .next_pixel(next_pixel),
        .lcd_cs(spi1_cs0),
        .lcd_clk(spi1_sclk),
        .lcd_mosi(spi1_mosi),
        .lcd_dc(lcd_dc),
        .reset(lcd_nrst)
    );

endmodule
