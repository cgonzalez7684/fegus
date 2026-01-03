

namespace Application.Interfaces;

public interface IDeudorRepository
{
    Task<Deudor?> GetDeudorByIdAsync(int idCliente, string idDeudor);
}
