namespace FegusDAgent.Domain.Entities;

/// <summary>
/// Configuración de caja devuelta por GET /fegusconfig/box/{idCliente}.
/// </summary>
/// <remarks>Ajustar las propiedades según el esquema real del API.</remarks>
public sealed class FeBoxDataLoad
{
    public int? IdCliente { get; set; }
    public int? IdLoad { get; set; }
    public int? IdLoadLocal { get; set; }
    public string? StateCode { get; set; }
    public string? IsActive { get; set; }
    public DateTime? AsofDate { get; set; }
    public DateTime CreatedAtUtc { get; set; }
    public DateTime? UpdatedAtUtc { get; set; }
}
