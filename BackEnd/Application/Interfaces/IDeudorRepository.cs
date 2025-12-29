namespace Application.Interfaces;

public interface IDeudorRepository
{
    Task<DeudorDto?> GetDeudorByIdAsync(int idCliente, string idDeudor);
}
