

namespace Application.Interfaces;

public interface IDeudorRepository
{
    Task<Deudor?> GetDeudorByIdAsync(int idCliente, string idDeudor);

    Task<IEnumerable<Deudor>> GetDeudoresAsync(int idCliente);
}
