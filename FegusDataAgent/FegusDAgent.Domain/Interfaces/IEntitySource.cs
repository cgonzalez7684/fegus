using System;
using FegusDAgent.Domain.Entities;

namespace FegusDAgent.Domain.Interfaces;

public interface IEntitySource<T>
{
    IAsyncEnumerable<T> GetDataStreamAsync(        
        int? idLoadLocal,
        CancellationToken cancellationToken);
}
