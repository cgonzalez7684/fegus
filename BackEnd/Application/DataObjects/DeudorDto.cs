using System;

namespace Application.DataObjects;

public class DeudorDto
{
    public int id_cliente { get; set; }
    public int tipodeudorsfn { get; set; }
    public int tipopersonadeudor { get; set; }
    public string?  iddeudor { get; set; }
    public decimal saldototalsegmentacion { get; set; }

}
