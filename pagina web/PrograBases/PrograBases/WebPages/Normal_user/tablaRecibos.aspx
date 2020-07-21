<%@ Page Title="" Language="C#" MasterPageFile="~/WebPages/Normal_user/NormalUser_Site.Master" AutoEventWireup="true" CodeBehind="tablaRecibos.aspx.cs" Inherits="PrograBases.WebPages.Normal_user.tablaRecibos" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link rel="stylesheet" href="/css/Normal_user/tablaRecibos.css" type="text/css" media="screen" />

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="flexBoxRecibosContainer">
        <div id="wrap-table">
            <table border="1" id="tableHeader">
                <thead>
				    <tr class="row100 head">
					    <th class="cell100 column1" style="width:10%">Id Concepto de cobro</th>
					    <th class="cell100 column2" style="width:19%">Monto</th>
					    <th class="cell100 column3" style="width:15%">Estado</th>
					    <th class="cell100 column4" style="width:15%">Fecha</th>
					    <th class="cell100 column5" style="width:15%">Fecha Vencimiento</th>
					    <th class="cell100 column5" style="width:12%">Comprobantes de pago</th>
				    </tr>
			    </thead>        
            </table>

            <div id="divTablaRecibos">
                <asp:GridView runat="server" CssClass="gridNormalUser" id="GridRecibos" AutoGenerateColumns="false" Visible="false" ShowFooter="false" ShowHeader="false" CellPadding="3" DataKeyNames = "id">
                    <Columns>
                        <asp:BoundField HeaderText="Id" DataField="id" InsertVisible="False" ReadOnly="True" SortExpression="id" Visible="false"/>
                        <asp:BoundField HeaderText="Id Concepto de cobro" DataField="id_CC" InsertVisible="False" ReadOnly="True" SortExpression="id_CC" ItemStyle-Width="10%"/>
                        <asp:BoundField HeaderText="Monto" DataField="monto" InsertVisible="False" ReadOnly="True" SortExpression="monto" ItemStyle-Width="19%"/>
                        <asp:BoundField HeaderText="Estado" DataField="estado" InsertVisible="False" ReadOnly="True" SortExpression="estado" ItemStyle-Width="15%"/>
                        <asp:BoundField HeaderText="Fecha" DataField="fecha" InsertVisible="False" ReadOnly="True" SortExpression="fecha" ItemStyle-Width="15%"/>
                        <asp:BoundField HeaderText="Fecha Vencimiento" DataField="fechaVence" InsertVisible="False" ReadOnly="True" SortExpression="fechaVence" ItemStyle-Width="15%"/>
                        <asp:TemplateField HeaderText="" ShowHeader="False">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkvVerComprobantesDePago" runat="server" CausesValidation="True" Text="Comprobantes de pago" OnClick="lnkvVerComprobantesDePago_Click"></asp:LinkButton>
                            </ItemTemplate>
                            <ItemStyle Width="12%"/>
                        </asp:TemplateField>
                    </Columns>
                    <HeaderStyle BackColor="#222222" Font-Bold="True" ForeColor="White" HorizontalAlign="Center"/>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>
