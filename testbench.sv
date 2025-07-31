`include "axi_pkg.sv"
`include "axi_if.sv"
module top;
import uvm_pkg::*;
import Axi_pkg::*;

bit clock;
bit reset;
//---------------------------------------
//clock generation
//---------------------------------------
always #5 clock = ~clock;

//---------------------------------------
//reset Generation
//---------------------------------------
  initial begin
    reset = 1;
    #5 reset =0;
  end  

//---------------------------------------
//Interface Instance
//---------------------------------------  
  
  axi #(.S_COUNT(2),.M_COUNT(2)) in0(clock,reset);
  
//---------------------------------------
//DUT instance
//---------------------------------------
  axi_interconnect #(.S_COUNT(2),.M_COUNT(2)) 
     dut(
      .clk(in0.ACLK),
      .rst(in0.ARESETn),
      .s_axi_awid(in0.s_axi_awid),
      .s_axi_awaddr(in0.s_axi_awaddr),
      .s_axi_awlen(in0.s_axi_awlen),
      .s_axi_awsize(in0.s_axi_awsize),
      .s_axi_awburst(in0.s_axi_awburst),
      .s_axi_awlock(in0.s_axi_awlock),
      .s_axi_awcache(in0.s_axi_awcache),
      .s_axi_awprot(in0.s_axi_awprot),
      .s_axi_awqos(in0.s_axi_awqos),
      .s_axi_awuser(in0.s_axi_awuser),
      .s_axi_awvalid(in0.s_axi_awvalid),
      .s_axi_awready(in0.s_axi_awready),
      .s_axi_wdata(in0.s_axi_wdata),
      .s_axi_wstrb(in0.s_axi_wstrb),
      .s_axi_wlast(in0.s_axi_wlast),
      .s_axi_wuser(in0.s_axi_wuser),
      .s_axi_wvalid(in0.s_axi_wvalid),
      .s_axi_wready(in0.s_axi_wready),
      .s_axi_bid(in0.s_axi_bid),
      .s_axi_bresp(in0.s_axi_bresp),
      .s_axi_buser(in0.s_axi_buser),
      .s_axi_bvalid(in0.s_axi_bvalid),
      .s_axi_bready(in0.s_axi_bready),
      .s_axi_arid(in0.s_axi_arid),
      .s_axi_araddr(in0.s_axi_araddr),
      .s_axi_arlen(in0.s_axi_arlen),
      .s_axi_arsize(in0.s_axi_arsize),
      .s_axi_arburst(in0.s_axi_arburst),
      .s_axi_arlock(in0.s_axi_arlock),
      .s_axi_arcache(in0.s_axi_arcache),
      .s_axi_arprot(in0.s_axi_arprot),
      .s_axi_arqos(in0.s_axi_arqos),
      .s_axi_aruser(in0.s_axi_aruser),
      .s_axi_arvalid(in0.s_axi_arvalid),
      .s_axi_arready(in0.s_axi_arready),
      .s_axi_rid(in0.s_axi_rid),
      .s_axi_rdata(in0.s_axi_rdata),
      .s_axi_rresp(in0.s_axi_rresp),
      .s_axi_rlast(in0.s_axi_rlast),
      .s_axi_ruser(in0.s_axi_ruser),
      .s_axi_rvalid(in0.s_axi_rvalid),
      .s_axi_rready(in0.s_axi_rready),
      .m_axi_awid(in0.m_axi_awid),
      .m_axi_awaddr(in0.m_axi_awaddr),
      .m_axi_awlen(in0.m_axi_awlen),
      .m_axi_awsize(in0.m_axi_awsize),
      .m_axi_awburst(in0.m_axi_awburst),
      .m_axi_awlock(in0.m_axi_awlock),
      .m_axi_awcache(in0.m_axi_awcache),
      .m_axi_awprot(in0.m_axi_awprot),
      .m_axi_awqos(in0.m_axi_awqos),
      .m_axi_awregion(in0.m_axi_awregion),
      .m_axi_awuser(in0.m_axi_awuser),
      .m_axi_awvalid(in0.m_axi_awvalid),
      .m_axi_awready(in0.m_axi_awready),
      .m_axi_wdata(in0.m_axi_wdata),
      .m_axi_wstrb(in0.m_axi_wstrb),
      .m_axi_wlast(in0.m_axi_wlast),
      .m_axi_wuser(in0.m_axi_wuser),
      .m_axi_wvalid(in0.m_axi_wvalid),
      .m_axi_wready(in0.m_axi_wready),
      .m_axi_bid(in0.m_axi_bid),
      .m_axi_bresp(in0.m_axi_bresp),
      .m_axi_buser(in0.m_axi_buser),
      .m_axi_bvalid(in0.m_axi_bvalid),
      .m_axi_bready(in0.m_axi_bready),
      .m_axi_arid(in0.m_axi_arid),
      .m_axi_araddr(in0.m_axi_araddr),
      .m_axi_arlen(in0.m_axi_arlen),
      .m_axi_arsize(in0.m_axi_arsize),
      .m_axi_arburst(in0.m_axi_arburst),
      .m_axi_arlock(in0.m_axi_arlock),
      .m_axi_arcache(in0.m_axi_arcache),
      .m_axi_arprot(in0.m_axi_arprot),
      .m_axi_arqos(in0.m_axi_arqos),
      .m_axi_arregion(in0.m_axi_arregion),
      .m_axi_aruser(in0.m_axi_aruser),
      .m_axi_arvalid(in0.m_axi_arvalid),
      .m_axi_arready(in0.m_axi_arready),
      .m_axi_rid(in0.m_axi_rid),
      .m_axi_rdata(in0.m_axi_rdata),
      .m_axi_rresp(in0.m_axi_rresp),
      .m_axi_rlast(in0.m_axi_rlast),
      .m_axi_ruser(in0.m_axi_ruser),
      .m_axi_rvalid(in0.m_axi_rvalid),
      .m_axi_rready(in0.m_axi_rready)  
  );  
  
  
initial begin
   $dumpfile("dump.vcd");
   $dumpvars;
end

initial 
begin
  uvm_config_db #(virtual axi #(.S_COUNT(2),.M_COUNT(2))) :: set(null,"*","axi",in0);
uvm_top.enable_print_topology = 1;
  run_test("fixed_test");
end
endmodule
