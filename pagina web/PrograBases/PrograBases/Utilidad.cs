using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace PrograBases
{
    public static class Utilidad
    {
        public static string verificarString_nombres(string pString)
        {
            pString = pString.Trim();
            bool isIntString = pString.All(char.IsDigit);
            if (isIntString || String.IsNullOrEmpty(pString))
            {
                return "-1";
            }
            else
                return pString;
        }

        public static string mensajeAlerta(SqlException ex)
        {
            string mensaje = ex.Errors[0].ToString();

            return mensaje;
        }
    }
}