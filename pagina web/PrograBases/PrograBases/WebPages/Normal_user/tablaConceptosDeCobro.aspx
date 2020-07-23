<%@ Page Title="" Language="C#" MasterPageFile="~/WebPages/Normal_user/NormalUser_Site.Master" AutoEventWireup="true" CodeBehind="tablaConceptosDeCobro.aspx.cs" Inherits="PrograBases.WebPages.Normal_user.tablaConceptosDeCobro" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link rel="stylesheet" href="/css/Normal_user/tablaConceptosDeCobro.css" type="text/css" media="screen" />

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="flexBoxConceptosDeCobroContainer">
        <div id="wrap-table">
            <table border="1" id="tableHeader">
                <thead>
                    <tr>
                        <th class="cell100 column1" style="width:10%">Id</th>
					    <th class="cell100 column2" style="width:10%">Nombre</th>
					    <th class="cell100 column3" style="width:10%">Dias para vencer</th>
					    <th class="cell100 column4" style="width:10%">Dia De Cobro</th>
					    <th class="cell100 column5" style="width:10%">Tasa impuesto moratorio</th>
                        <th class="cell100 column6" style="width:10%">Es impuesto</th>
					    <th class="cell100 column7" style="width:10%">Es recurrente</th>
                        <th class="cell100 column8" style="width:10%">Es fijo</th>
                        <th class="cell100 column9" style="width:10%">Monto</th>
                        <th class="cell100 column10" style="width:10%">Valor por m3</th>
                    </tr>
                </thead>
            </table>

            <div id="divTablaConceptosDeCobro">
                <asp:GridView runat="server" CssClass="gridNormalUser" id="GridConceptosDeCobro" AutoGenerateColumns="false" Visible="false" ShowFooter="false" ShowHeader="false" CellPadding="3" DataKeyNames="id">
                    <Columns>              
                        <asp:BoundField HeaderText="Id" DataField="id" InsertVisible="False" ReadOnly="True" SortExpression="id" ItemStyle-Width="10%" />

                        <asp:BoundField HeaderText="Nombre" DataField="nombre" InsertVisible="False" ReadOnly="True" SortExpression="nombre" ItemStyle-Width="10%" />

                        <asp:BoundField HeaderText="Dias para vencer" DataField="diasParaVencer" InsertVisible="False" ReadOnly="True" SortExpression="diasParaVencer" ItemStyle-Width="10%" />

                        <asp:BoundField HeaderText="Dia De Cobro" DataField="diaDeCobro" InsertVisible="False" ReadOnly="True" SortExpression="diaDeCobro" ItemStyle-Width="10%" />

                        <asp:BoundField HeaderText="Tasa impuesto moratorio" DataField="tasaImpuestoMoratorio" InsertVisible="False" ReadOnly="True" SortExpression="tasaImpuestoMoratorio" ItemStyle-Width="10%" />

                        <asp:BoundField HeaderText="Es impuesto" DataField="esImpuesto" InsertVisible="False" ReadOnly="True" SortExpression="esImpuesto" ItemStyle-Width="10%" />

                        <asp:BoundField HeaderText="Es recurrente" DataField="esRecurrente" InsertVisible="False" ReadOnly="True" SortExpression="esRecurrente" ItemStyle-Width="10%" />

                        <asp:BoundField HeaderText="Es fijo" DataField="esFijo" InsertVisible="False" ReadOnly="True" SortExpression="esFijo" ItemStyle-Width="10%" />

                        <asp:BoundField HeaderText="Monto" DataField="monto" InsertVisible="False" ReadOnly="True" SortExpression="monto" ItemStyle-Width="10%" />

                        <asp:BoundField HeaderText="Valor por m3" DataField="valorPorM3" InsertVisible="False" ReadOnly="True" SortExpression="valorPorM3" ItemStyle-Width="10%" />

                    </Columns>
                    <HeaderStyle BackColor="#222222" Font-Bold="True" ForeColor="White" HorizontalAlign="Center"/>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>
