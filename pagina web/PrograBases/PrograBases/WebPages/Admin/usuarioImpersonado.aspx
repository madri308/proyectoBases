<%@ Page Title="" Language="C#" MasterPageFile="~/WebPages/Admin/Admin_Site.Master" AutoEventWireup="true" CodeBehind="usuarioImpersonado.aspx.cs" Inherits="PrograBases.WebPages.Admin.usuarioImpersonado" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link href="../../css/Admin/usuarioImpersonado.css" rel="stylesheet" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge"> 

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">


    <div runat="server" class="flexBoxContainer" id="divPropiedades">
        <div class="wrap-table">
            <table border="1" class="tableHeader">
                <thead>
				    <tr class="row100 head">
					    <th class="cell100 column1" style="width:14%">Numero de Finca</th>
					    <th class="cell100 column2" style="width:14%">Valor</th>
					    <th class="cell100 column3" style="width:26%">Direccion</th>
					    <th class="cell100 column5" style="width:11%">Recibos pagados</th>
					    <th class="cell100 column5" style="width:11%">Recibos pendientes</th>
					    <th class="cell100 column5" style="width:11%">Comprobantes de pago</th>
                        <th class="cell100 column5" style="width:11%">Arreglos de pago</th>
				    </tr>
			    </thead>  
            </table>	

			<div class="divTabla" id="divTablaPropiedades">
                <asp:GridView runat="server" CssClass="grid" id="GridPropiedades" AutoGenerateColumns="false" Visible="false" ShowFooter="false" ShowHeader="false" CellPadding="3" DataKeyNames="numFinca" >
                    <Columns>
                        <asp:BoundField HeaderText="Numero de Finca" DataField="numFinca" InsertVisible="False" ReadOnly="True" SortExpression="numFinca" ItemStyle-Width="14%"/>

                        <asp:BoundField HeaderText="Valor" DataField="valor"  InsertVisible="False" ReadOnly="True" SortExpression="valor" ItemStyle-Width="14%"/>

                        <asp:BoundField HeaderText="Direccion" DataField="direccion" InsertVisible="False" ReadOnly="True" SortExpression="direccion" ItemStyle-Width="26%"/>

                        <asp:TemplateField HeaderText="" ShowHeader="False">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkvVerRecibosPagados" runat="server" CausesValidation="True" Text="Recibos pagados" OnClick="lnkvVerRecibosPagados_Click"></asp:LinkButton>
                            </ItemTemplate>
                            <ItemStyle Width="11%"/>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="" ShowHeader="False">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkvVerRecibosPendientes" runat="server" CausesValidation="True" Text="Recibos pendientes" OnClick="lnkvVerRecibosPendientes_Click"></asp:LinkButton>
                            </ItemTemplate>
                            <ItemStyle Width="11%"/>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="" ShowHeader="False">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkvVerComprobantesDePago" runat="server" CausesValidation="True" Text="Comprobantes de pago" OnClick="lnkvVerComprobantesDePago_Click"></asp:LinkButton>
                            </ItemTemplate>
                            <ItemStyle Width="11%"/>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="" ShowHeader="False">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkvVerArreglosDePago" runat="server" CausesValidation="True" Text="Arreglos de pago" OnClick="lnkvVerArreglosDePago_Click"></asp:LinkButton>
                            </ItemTemplate>
                            <ItemStyle Width="11%"/>
                        </asp:TemplateField>

                    </Columns>
                    <HeaderStyle BackColor="#222222" Font-Bold="True" ForeColor="White" HorizontalAlign="Center" />

                </asp:GridView>
            </div>
        </div>
    </div>

    <div runat="server" class="flexBoxContainer" visible="false" id="divRecibos">

        <div class="wrap-table">
            <table border="1" class="tableHeader">
                <thead>
				    <tr class="row100 head">
					    <th class="cell100 column1" style="width:10%">Id Concepto de cobro</th>
					    <th class="cell100 column3" style="width:18%">Estado</th>
					    <th class="cell100 column4" style="width:18%">Fecha</th>
					    <th class="cell100 column5" style="width:18%">Fecha Vencimiento</th>
					    <th class="cell100 column2" style="width:19%">Monto</th>
                        <th class="cell100 column5" style="width:3%"></th>
				    </tr>
			    </thead>        
            </table>

            <div class="divTabla" id="divTablaRecibos">
                <asp:GridView runat="server" CssClass="grid" id="GridRecibos" AutoGenerateColumns="false" Visible="false" ShowFooter="false" ShowHeader="false" CellPadding="3" DataKeyNames = "id">
                    <Columns>
                        <asp:BoundField HeaderText="Id Concepto de cobro" DataField="id_CC" InsertVisible="False" ReadOnly="True" SortExpression="id_CC" ItemStyle-Width="10%"/>
                        <asp:BoundField HeaderText="Estado" DataField="estado" InsertVisible="False" ReadOnly="True" SortExpression="estado" ItemStyle-Width="18%"/>
                        <asp:BoundField HeaderText="Fecha" DataField="fecha" InsertVisible="False" ReadOnly="True" SortExpression="fecha" ItemStyle-Width="18%"/>
                        <asp:BoundField HeaderText="Fecha Vencimiento" DataField="fechaVence" InsertVisible="False" ReadOnly="True" SortExpression="fechaVence" ItemStyle-Width="18%"/>
                        <asp:BoundField HeaderText="Monto" DataField="monto" InsertVisible="False" ReadOnly="True" SortExpression="monto" ItemStyle-Width="19%"/>
                        <asp:TemplateField HeaderText="" ShowHeader="False">
                            <ItemTemplate>
                                <asp:CheckBox runat="server" ID="checkBoxRecibo"/>
                            </ItemTemplate>
                            <ItemStyle Width="3%"/>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle BackColor="#222222" Font-Bold="True" ForeColor="White" HorizontalAlign="Center"/>
                </asp:GridView>

                <div>
                    <asp:Label runat="server" Text="Plazo: " CssClass="labelPlazo"></asp:Label>
                    <asp:DropDownList runat="server" CssClass="ddlAP" ID="listaPlazoDeAP">
                    
                        <asp:ListItem Text="3 meses" Value="3"></asp:ListItem>
                        <asp:ListItem Text="4 meses" Value="4"></asp:ListItem>
                        <asp:ListItem Text="5 meses" Value="5"></asp:ListItem>
                        <asp:ListItem Text="6 meses" Value="6"></asp:ListItem>
                        <asp:ListItem Text="7 meses" Value="7"></asp:ListItem>
                        <asp:ListItem Text="8 meses" Value="8"></asp:ListItem>
                        <asp:ListItem Text="9 meses" Value="9"></asp:ListItem>
                        <asp:ListItem Text="10 meses" Value="10"></asp:ListItem>
                        <asp:ListItem Text="11 meses" Value="11"></asp:ListItem>
                        <asp:ListItem Text="12 meses" Value="12"></asp:ListItem>

                    </asp:DropDownList>
                </div>
                <asp:Label runat="server" CssClass="labelError" ID="labelErrorPagoRecibos" Text="Error" Visible="false"></asp:Label>
            </div>
            <asp:Button runat="server" CssClass="botonRecibos" ID="botonCrearAP" Text="Arreglo de Pago" OnClick="botonCrearAP_Click"/>
            
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

                <asp:Label runat="server" ID="labelResultadoCuota" Text=""></asp:Label>
                
                <div id="divButtonContainer">
                    <asp:Button runat="server" CssClass="botonRecibos botonCancelar" ID="botonCancelarAP" Text="Cancelar arreglo de pago" OnClick="botonCancelarAP_Click"/>
                    <asp:Button runat="server" CssClass="botonRecibos botonConfirmar" ID="botonConfirmarAP" Text="Confirmar arreglo de pago" OnClick="botonConfirmarAP_Click"/>
                </div>
            </div>
        </div>
    </div>

    <div runat="server"  class="flexBoxContainer" visible="false" id="divComprobantesDePagoContainer">
        <div id="wrap-table">
            <table border="1" class="tableHeader">
                <thead>
				    <tr class="row100 head">
					    <th class="cell100 column1" style="width:30%">Fecha</th>
					    <th class="cell100 column2" style="width:39%">Total</th>
					    <th class="cell100 column3" style="width:30%">Ver recibos</th>
				    </tr>
			    </thead>        
            </table>

            <div class="divTabla" id="divTablaComprobantesDePago">
                <asp:GridView runat="server" CssClass="grid" id="GridComprobantesDePago" AutoGenerateColumns="false" Visible="false" ShowFooter="false" ShowHeader="false" CellPadding="3" DataKeyNames="id">
                    <Columns>
                        <asp:BoundField HeaderText="" DataField="id" InsertVisible="False" ReadOnly="True" SortExpression="id" Visible="false" />

                        <asp:BoundField HeaderText="Fecha" DataField="fecha" InsertVisible="False" ReadOnly="True" SortExpression="fecha" ItemStyle-Width="30%"/>

                        <asp:BoundField HeaderText="Total" DataField="total" InsertVisible="False" ReadOnly="True" SortExpression="total" ItemStyle-Width="39%"/>

                        <asp:TemplateField HeaderText="" ShowHeader="False">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkvVerRecibosDeComprobante" runat="server" CausesValidation="True" Text="Recibos pagados" OnClick="lnkvVerRecibosDeComprobante_Click"></asp:LinkButton>
                                </ItemTemplate>
                                <ItemStyle Width="30%" />
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle BackColor="#222222" Font-Bold="True" ForeColor="White" HorizontalAlign="Center"/>
                </asp:GridView>
            </div>
        </div>
    </div>

    <asp:Button runat="server" CssClass="botonRecibos" id="botonVolverAPropiedades" Text="Volver a propiedades" OnClick="botonVolverAPropiedades_Click"/>
</asp:Content>
