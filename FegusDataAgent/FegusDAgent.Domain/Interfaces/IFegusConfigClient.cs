using FegusDAgent.Domain.Entities;

namespace FegusDAgent.Domain.Interfaces;

/// <summary>
/// Cliente HTTP hacia el endpoint GET /fegusconfig/box/{idCliente} del API Fegus.
/// </summary>
public interface IFegusConfigClient
{
    /// <summary>
    /// Obtiene la configuración de caja del cliente.
    /// Devuelve null si la respuesta no es exitosa o no se puede deserializar.
    /// </summary>
    Task<FeBoxDataLoad?> GetNextBoxDataLoadAsync(int idCliente, CancellationToken cancellationToken = default);

    /// <summary>
    /// Actualiza la caja en el API Fegus via PUT /fegusconfig/box.
    /// Requiere autenticación Bearer. Devuelve true si la operación fue exitosa.
    /// </summary>
    Task<bool> UpdateFeBoxDataLoadAsync(string token,FeBoxDataLoad box, CancellationToken cancellationToken = default);
}
