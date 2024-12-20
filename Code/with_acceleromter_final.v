module with_acceleromter_final(
    input clk,
    input reset,            
    
    output wire mole, 
    output wire mole2, 
    output wire mole3, 
    output wire mole4,           // Mole visibility (1 for mole shown, 0 for hidden)
    
    output wire [6:0] score,    // Player score
    output wire [1:0] lives,    // Player lives
    output wire [2:0] state,     // Game state (IDLE, GAMEPLAY, END_SCREEN)
    
    ///////////////////////////////////////////////////////////////////////// new code
    input ACL_MISO,             // master in
    output ACL_MOSI,            // master out
    output ACL_SCLK,            // spi sclk
    output ACL_CSN             // spi ~chip select
    
    );
    
    wire clean;
    wire clean2;
    wire clean3;
    wire clean4;
    
    //////////new code////////////////
    wire w_4MHz;
    wire [14:0] acl_data;
    
    wire button4;
    wire button2;
    wire button3;
    wire button;
        
    iclk_gen clock_generation(
        .CLK100MHZ(clk),
        .clk_4MHz(w_4MHz)
    );
    
    spi_master master(
        .iclk(w_4MHz),
        .miso(ACL_MISO),
        .sclk(ACL_SCLK),
        .mosi(ACL_MOSI),
        .cs(ACL_CSN),
        .acl_data(acl_data)
    );
    
    button_control button_control(
        .acl_data(acl_data), 
        .right_button(button4),
        .left_button(button2),
        .up_button(button3),
        .bottom_button(button)
    );
    
    
    /////////////////////////////////
    
    debouncer DEB(clk, button, clean);
    debouncer DEB2(clk, button2, clean2);
    debouncer DEB3(clk, button3, clean3);
    debouncer DEB4(clk, button4, clean4);
    
    whack_a_mole_advanced DEBWAM(clk, reset, clean, clean2, clean3, clean4, mole, mole2, mole3, mole4, score, lives, state);
endmodule
