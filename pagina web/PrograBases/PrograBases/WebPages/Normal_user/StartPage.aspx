<%@ Page Title="" Language="C#" MasterPageFile="~/WebPages/Normal_user/NormalUser_Site.Master" AutoEventWireup="true" CodeBehind="StartPage.aspx.cs" Inherits="PrograBases.WebPages.Normal_user.StartPage1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link rel="stylesheet" href="/css/Normal_user/StartPage.css" type="text/css" media="screen" />

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="flexBoxPropiedadesContainer">
        <div id="wrap-table">
            <table border="1" id="tableHeader">
                <thead>
				    <tr class="row100 head">
					    <th class="cell100 column1" style="width:10%">Numero de Finca</th>
					    <th class="cell100 column2" style="width:12%">Valor</th>
					    <th class="cell100 column3" style="width:24%">Direccion</th>
					    <th class="cell100 column4" style="width:11%">Conceptos de cobro</th>
					    <th class="cell100 column5" style="width:11%">Recibos pagados</th>
					    <th class="cell100 column5" style="width:11%">Recibos pendientes</th>
					    <th class="cell100 column5" style="width:11%">Comprobantes de pago</th>
                        <th class="cell100 column5" style="width:11%">Arreglos de pago</th>
				    </tr>
			    </thead>        
            </table>

            <div id="divTablaPropiedades">
                <asp:GridView runat="server" CssClass="gridNormalUser" id="GridPropiedades" AutoGenerateColumns="false" Visible="false" ShowFooter="false" ShowHeader="false" CellPadding="3" DataKeyNames="numFinca" >
                    <Columns>
                        <asp:BoundField HeaderText="Numero de Finca" DataField="numFinca" InsertVisible="False" ReadOnly="True" SortExpression="numFinca" ItemStyle-Width="10%"/>

                        <asp:BoundField HeaderText="Valor" DataField="valor"  InsertVisible="False" ReadOnly="True" SortExpression="valor" ItemStyle-Width="12%"/>

                        <asp:BoundField HeaderText="Direccion" DataField="direccion" InsertVisible="False" ReadOnly="True" SortExpression="direccion" ItemStyle-Width="24%"/>

                        <asp:TemplateField HeaderText="" ShowHeader="False">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkvVerConceptosDeCobro" runat="server" CausesValidation="True" Text="Conceptos de cobro" OnClick="lnkvVerConceptosDeCobro_Click"></asp:LinkButton>
                            </ItemTemplate>
                            <ItemStyle Width="11%"/>
                        </asp:TemplateField>

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

</asp:Content>
