using System;
using Application.DataObjects;

namespace Application.Interfaces;

public interface IDeudorRepository
{
    Task<DeudorDto?> ObtenerDeudorAsync(int idCliente, string idDeudor);
}
