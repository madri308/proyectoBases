<%@ Page Title="" Language="C#" MasterPageFile="~/WebPages/Normal_user/NormalUser_Site.Master" AutoEventWireup="true" CodeBehind="tablaComprobantesDePago.aspx.cs" Inherits="PrograBases.WebPages.Normal_user.tablaComprobantesDePago" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link rel="stylesheet" href="../../css/Normal_user/tablaComprobantesDePago.css" type="text/css" media="screen" />

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="flexBoxComprobantesDePagoContainer">
        <div id="wrap-table">
            <table border="1" id="tableHeader">
                <thead>
				    <tr class="row100 head">
					    <th class="cell100 column1" style="width:30%">Fecha</th>
					    <th class="cell100 column2" style="width:39%">Total</th>
					    <th class="cell100 column3" style="width:30%">Ver recibos</th>
				    </tr>
			    </thead>        
            </table>

            <div id="divTablaComprobantesDePago">
                <asp:GridView runat="server" CssClass="gridNormalUser" id="GridComprobantesDePago" AutoGenerateColumns="false" Visible="false" ShowFooter="false" ShowHeader="false" CellPadding="3" DataKeyNames="id">
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


</asp:Content>
