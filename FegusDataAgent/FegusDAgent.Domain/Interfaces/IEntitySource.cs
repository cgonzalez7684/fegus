using System;
using FegusDAgent.Domain.Entities;

namespace FegusDAgent.Domain.Interfaces;

public interface IEntitySource<T>
{
    IAsyncEnumerable<T> StreamAsync(        
        CancellationToken cancellationToken);
}
