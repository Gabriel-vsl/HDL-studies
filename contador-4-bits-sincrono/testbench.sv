// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

module tb_counter4;

logic clk;
logic rst_n;
logic en;
logic [3:0] count;
  
initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_counter4);
end

// Instanciação do DUT
counter4 DUT (
    .clk(clk),
    .rst_n(rst_n),
    .en(en),
    .count(count)
);

  
// Geração do clock (10 ns de período)


initial begin
    clk = 0;
    forever #5 clk = ~clk;
end


// Monitor


initial begin
    $display("Tempo\tclk\trst_n\ten\tcount");
    $monitor("%0t\t%b\t%b\t%b\t%0d",
             $time, clk, rst_n, en, count);
end


// Testes


integer i;
logic [3:0] expected;

initial begin


    // Inicialização


    rst_n = 1;
    en    = 0;
    expected = 0;


    // Teste 1 - Reset Assíncrono


    #2;
    rst_n = 0;

    #2;

    if (count !== 4'd0)
        $error("ERRO: Reset assíncrono falhou.");
    else
        $display("Teste Reset Assíncrono: PASSOU");

    #6;
    rst_n = 1;


    // Teste 2 - Enable = 0


    repeat (5) begin
        @(posedge clk);

        if (count !== 4'd0)
            $error("ERRO: Contador alterou com enable=0");
    end

    $display("Teste Enable=0: PASSOU");


    // Teste 3 - Contagem de 0 até 15


    en = 1;
    expected = 0;

    for(i=0; i<16; i++) begin

        @(posedge clk);

        expected = expected + 1;

        if(count !== expected)
            $error("ERRO: Esperado=%0d Obtido=%0d",
                    expected, count);

    end

    $display("Teste Contagem Crescente: PASSOU");


    // Teste 4 - Overflow


    @(posedge clk);

    if(count !== 4'd1)
        $error("ERRO Overflow");
    else
        $display("Teste Overflow: PASSOU");


    // Teste 5 - Desabilita durante contagem


    en = 0;

    repeat(4) begin

        @(posedge clk);

        if(count !== 4'd1)
            $error("ERRO: contador incrementou com enable=0");

    end

    $display("Teste Desabilitação: PASSOU");


    // Teste 6 - Reabilita


    en = 1;

    @(posedge clk);

    if(count !== 4'd2)
        $error("ERRO: contador não retomou corretamente");
    else
        $display("Teste Reabilitação: PASSOU");

  
    // Teste 7 - Reset durante contagem


    @(posedge clk);

    rst_n = 0;

    #1;

    if(count !== 4'd0)
        $error("ERRO: Reset durante contagem falhou");
    else
        $display("Teste Reset Durante Contagem: PASSOU");

    #9;
    rst_n = 1;


    // Teste Final


    en = 1;

    repeat(5)
        @(posedge clk);


    $display("Todos os testes foram executados.");


    #20;
    $finish;

end

endmodule
