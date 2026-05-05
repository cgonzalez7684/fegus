using System;
using System.Runtime.CompilerServices;
using FegusDAgent.Domain.Entities;

namespace FegusDAgent.Domain.Interfaces;

public interface IEntitySource<T>
{
    IAsyncEnumerable<T> GetDataStreamAsync(
        int? idCliente,
        long? idLoadLocal,
        CancellationToken cancellationToken);
}
