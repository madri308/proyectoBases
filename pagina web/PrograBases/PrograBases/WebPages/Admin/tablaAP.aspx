<%@ Page Title="" Language="C#" MasterPageFile="~/WebPages/Admin/Admin_Site.Master" AutoEventWireup="true" CodeBehind="tablaAP.aspx.cs" Inherits="PrograBases.WebPages.Admin.tablaAP" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link href="../../css/Normal_user/tablaAP.css" rel="stylesheet" />

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div runat="server" class="flexBoxContainer" id="divAP">
        <div class="wrap-table">
            <table border="1" class="tableHeader">
                <thead>
				    <tr class="row100 head">
					    <th class="cell100 column1" style="width:14%">Monto Original</th>
					    <th class="cell100 column2" style="width:14%">Saldo</th>
					    <th class="cell100 column3" style="width:14%">Tasa Interes Anual</th>
					    <th class="cell100 column5" style="width:14%">Plazo Original</th>
					    <th class="cell100 column5" style="width:14%">Plazo Restante</th>
				        <th class="cell100 column5" style="width:14%">Cuota</th>  
                        <th class="cell100 column5" style="width:14%"></th>
                    </tr>
			    </thead>  
            </table>	

			<div class="divTabla" id="divTablaAP">
                <asp:GridView runat="server" CssClass="grid" id="GridAP" AutoGenerateColumns="false" Visible="false" ShowFooter="false" ShowHeader="false" CellPadding="3" DataKeyNames="id" >
                    <Columns>
                        <asp:BoundField HeaderText="Monto Original" DataField="MontoOriginal" InsertVisible="False" ReadOnly="True" SortExpression="MontoOriginal" ItemStyle-Width="14%"/>

                        <asp:BoundField HeaderText="Saldo" DataField="saldo"  InsertVisible="False" ReadOnly="True" SortExpression="saldo" ItemStyle-Width="14%"/>

                        <asp:BoundField HeaderText="Tasa Interes Anual" DataField="TasaInteresAnual" InsertVisible="False" ReadOnly="True" SortExpression="TasaInteresAnual" ItemStyle-Width="14%"/>

                        <asp:BoundField HeaderText="Plazo Original" DataField="PlazoOriginal"  InsertVisible="False" ReadOnly="True" SortExpression="PlazoOriginal" ItemStyle-Width="14%"/>
                        
                        <asp:BoundField HeaderText="Plazo Restante" DataField="PlazoResta"  InsertVisible="False" ReadOnly="True" SortExpression="PlazoResta" ItemStyle-Width="14%"/>

                        <asp:BoundField HeaderText="Cuota" DataField="valor"  InsertVisible="False" ReadOnly="True" SortExpression="Cuota" ItemStyle-Width="14%"/>
                        
                        <asp:TemplateField HeaderText="" ShowHeader="False">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkvVerMovimientos" runat="server" CausesValidation="True" Text="Movimientos" Onclick="lnkvVerMovimientos_Click"></asp:LinkButton>
                            </ItemTemplate>
                            <ItemStyle Width="14%"/>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>

    <div runat="server" class="flexBoxContainer" id="divMovimientos" visible="false">
        <div class="wrap-table">
            <table border="1" class="tableHeader">
                <thead>
				    <tr class="row100 head">
					    <th class="cell100 column1" style="width:20%">Id tipo movimiento</th>
					    <th class="cell100 column2" style="width:20%">Monto</th>
					    <th class="cell100 column3" style="width:20%">Interes del mes</th>
					    <th class="cell100 column5" style="width:20%">Plazo restante</th>
					    <th class="cell100 column5" style="width:20%">Nuevo saldo</th>
                    </tr>
			    </thead>  
            </table>	

			<div class="divTabla" id="divTablaMovimientos">
                <asp:GridView runat="server" CssClass="grid" id="GridMovimientos" AutoGenerateColumns="false" Visible="false" ShowFooter="false" ShowHeader="false" CellPadding="3" DataKeyNames="id" >
                    <Columns>
                        <asp:BoundField HeaderText="Id Tipo Movimiento" DataField="idTipoMov" InsertVisible="False" ReadOnly="True" SortExpression="idTipoMov" ItemStyle-Width="20%"/>

                        <asp:BoundField HeaderText="Monto" DataField="Monto"  InsertVisible="False" ReadOnly="True" SortExpression="Monto" ItemStyle-Width="20%"/>

                        <asp:BoundField HeaderText="Interes Del Mes" DataField="interesDelMes" InsertVisible="False" ReadOnly="True" SortExpression="interesDelMes" ItemStyle-Width="20%"/>

                        <asp:BoundField HeaderText="Plazo restante" DataField="plazoResta"  InsertVisible="False" ReadOnly="True" SortExpression="plazoResta" ItemStyle-Width="20%"/>

                        <asp:BoundField HeaderText="Nuevo Saldo" DataField="nuevoSaldo"  InsertVisible="False" ReadOnly="True" SortExpression="nuevoSaldo" ItemStyle-Width="20%"/>
                        

                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
    <asp:Button runat="server" id="botonVolverAPropiedades" CssClass="botonRecibos" Text="Volver a propiedades" OnClick="botonVolverAPropiedades_Click"/>

</asp:Content>
