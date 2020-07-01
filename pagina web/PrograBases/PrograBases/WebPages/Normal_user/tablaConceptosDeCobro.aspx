<%@ Page Title="" Language="C#" MasterPageFile="~/WebPages/Normal_user/NormalUser_Site.Master" AutoEventWireup="true" CodeBehind="tablaConceptosDeCobro.aspx.cs" Inherits="PrograBases.WebPages.Normal_user.tablaConceptosDeCobro" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div id="divConceptosDeCobro" style="margin-left:11%">
        <asp:GridView runat="server" CssClass="gridNormalUser" id="GridConceptosDeCobro" AutoGenerateColumns="false" Visible="false" ShowFooter="True" CellPadding="3" DataKeyNames="id">
            <Columns>              
                <asp:BoundField HeaderText="Id" DataField="id" InsertVisible="False" ReadOnly="True" SortExpression="id" />

                <asp:BoundField HeaderText="Nombre" DataField="nombre" InsertVisible="False" ReadOnly="True" SortExpression="nombre" />

                <asp:BoundField HeaderText="Dias para vencer" DataField="diasParaVencer" InsertVisible="False" ReadOnly="True" SortExpression="diasParaVencer" />

                <asp:BoundField HeaderText="Dia De Cobro" DataField="diaDeCobro" InsertVisible="False" ReadOnly="True" SortExpression="diaDeCobro" />

                <asp:BoundField HeaderText="Tasa impuesto moratorio" DataField="tasaImpuestoMoratorio" InsertVisible="False" ReadOnly="True" SortExpression="tasaImpuestoMoratorio" />

                <asp:BoundField HeaderText="Es impuesto" DataField="esImpuesto" InsertVisible="False" ReadOnly="True" SortExpression="esImpuesto" />

                <asp:BoundField HeaderText="Es recurrente" DataField="esRecurrente" InsertVisible="False" ReadOnly="True" SortExpression="esRecurrente" />

                <asp:BoundField HeaderText="Es fijo" DataField="esFijo" InsertVisible="False" ReadOnly="True" SortExpression="esFijo" />

                <asp:BoundField HeaderText="Monto" DataField="monto" InsertVisible="False" ReadOnly="True" SortExpression="monto" />

            </Columns>
            <HeaderStyle BackColor="#222222" Font-Bold="True" ForeColor="White" HorizontalAlign="Center"/>
        </asp:GridView>
    </div>
</asp:Content>
