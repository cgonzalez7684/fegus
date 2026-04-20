using System;
using System.Runtime.CompilerServices;
using FegusDAgent.Domain.Entities;

namespace FegusDAgent.Domain.Interfaces;

public interface IEntitySource<T>
{
    IAsyncEnumerable<T> GetDataStreamAsync(        
        long? idLoadLocal,
        CancellationToken cancellationToken);

      
}
