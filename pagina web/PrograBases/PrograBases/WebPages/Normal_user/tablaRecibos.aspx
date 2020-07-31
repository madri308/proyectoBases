<%@ Page Title="" Language="C#" MasterPageFile="~/WebPages/Normal_user/NormalUser_Site.Master" AutoEventWireup="true" CodeBehind="tablaRecibos.aspx.cs" Inherits="PrograBases.WebPages.Normal_user.tablaRecibos" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link rel="stylesheet" href="/css/Normal_user/tablaRecibos.css" type="text/css" media="screen" />

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="flexBoxRecibosContainer">

        <div id="wrap-table">
            <table border="1" class="tableHeader">
                <thead>
				    <tr class="row100 head">
					    <th class="cell100 column1" style="width:8%">Id Concepto de cobro</th>
					    <th class="cell100 column3" style="width:12%">Estado</th>
					    <th class="cell100 column4" style="width:12%">Fecha</th>
					    <th class="cell100 column5" style="width:12%">Fecha Vencimiento</th>
					    <th class="cell100 column2" style="width:17%">Monto</th>
                        <th class="cell100 column2" style="width:12%">Descripcion</th>
					    <th class="cell100 column5" style="width:10%">Comprobantes de pago</th>
                        <th class="cell100 column5" style="width:3%"></th>
				    </tr>
			    </thead>        
            </table>

            <div id="divTablaRecibos">
                <asp:GridView runat="server" CssClass="gridNormalUser" id="GridRecibos" AutoGenerateColumns="false" Visible="false" ShowFooter="false" ShowHeader="false" CellPadding="3" DataKeyNames = "id">
                    <Columns>
                        <asp:BoundField HeaderText="Id Concepto de cobro" DataField="id_CC" InsertVisible="False" ReadOnly="True" SortExpression="id_CC" ItemStyle-Width="8%"/>
                        <asp:BoundField HeaderText="Estado" DataField="estado" InsertVisible="False" ReadOnly="True" SortExpression="estado" ItemStyle-Width="12%"/>
                        <asp:BoundField HeaderText="Fecha" DataField="fecha" InsertVisible="False" ReadOnly="True" SortExpression="fecha" ItemStyle-Width="12%"/>
                        <asp:BoundField HeaderText="Fecha Vencimiento" DataField="fechaVence" InsertVisible="False" ReadOnly="True" SortExpression="fechaVence" ItemStyle-Width="12%"/>
                        <asp:BoundField HeaderText="Monto" DataField="monto" InsertVisible="False" ReadOnly="True" SortExpression="monto" ItemStyle-Width="17%"/>
                        <asp:BoundField HeaderText="Descripcion" DataField="descripcion" InsertVisible="False" ReadOnly="True" SortExpression="descripcion" ItemStyle-Width="12%"/>
                        <asp:TemplateField HeaderText="" ShowHeader="False">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkvVerComprobantesDePago" runat="server" CausesValidation="True" Text="Comprobantes de pago" OnClick="lnkvVerComprobantesDePago_Click"></asp:LinkButton>
                            </ItemTemplate>
                            <ItemStyle Width="10%"/>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="" ShowHeader="False">
                            <ItemTemplate>
                                <asp:CheckBox runat="server" ID="checkBoxRecibo"/>
                            </ItemTemplate>
                            <ItemStyle Width="3%"/>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle BackColor="#222222" Font-Bold="True" ForeColor="White" HorizontalAlign="Center"/>
                </asp:GridView>
                <asp:Label runat="server"  CssClass="labelError" ID="labelErrorPagoRecibos" Text="Error" Visible="false"></asp:Label>
            </div>
            <asp:Button runat="server" CssClass="botonRecibos" ID="botonPagarRecibos" onClick="botonPagarRecibos_Click" Text="Pagar"/>
            
            <div runat="server" id="divTablaConfirmacionDePago" visible="false">
                <table border="1" class="tableHeader">
                    <thead>
				        <tr class="row100 head">
					        <th class="cell100 column1" style="width:10%">Id Concepto de cobro</th>
					        <th class="cell100 column4" style="width:14%">Fecha</th>
					        <th class="cell100 column5" style="width:14%">Fecha Vencimiento</th>
					        <th class="cell100 column2" style="width:19%">Monto</th>
				        </tr>
			        </thead>        
                </table>

                <asp:GridView runat="server" CssClass="gridNormalUser" id="GridComfirmacionDePago" AutoGenerateColumns="false" Visible="false" ShowFooter="true" ShowHeader="false" CellPadding="3">
                    <Columns>
                        <asp:BoundField HeaderText="Id Concepto de cobro" DataField="id_CC" InsertVisible="False" ReadOnly="True" SortExpression="id_CC" ItemStyle-Width="10%"/>
                        <asp:BoundField HeaderText="Fecha" DataField="fecha" InsertVisible="False" ReadOnly="True" SortExpression="fecha" ItemStyle-Width="14%"/>
                        <asp:BoundField HeaderText="Fecha Vencimiento" DataField="fechaVence" InsertVisible="False" ReadOnly="True" SortExpression="fechaVence" ItemStyle-Width="14%"/>
                        <asp:TemplateField HeaderText="Monto">
                            <ItemTemplate>
                                <asp:Label runat="server" ID="labelMonto" Text='<%# Bind("monto") %>'></asp:Label>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Label runat="server" id="labelTotal" Text="Total"></asp:Label>
                            </FooterTemplate>

                            <ItemStyle Width="19%" />
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle BackColor="#222222" Font-Bold="True" ForeColor="White" HorizontalAlign="Center"/>
                </asp:GridView>
                <div id="divButtonContainer">
                    <asp:Button runat="server" CssClass="botonRecibos botonCancelar" ID="botonCancelarPago" onClick="botonCancelarPago_Click" Text="Cancelar Pago"/>
                    <asp:Button runat="server" CssClass="botonRecibos botonConfirmar" ID="botonConfirmarPago" onClick="botonConfirmarPago_Click" Text="Confirmar pago"/>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
