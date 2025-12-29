namespace Common.Interfaces;


public interface IQuery : IRequest<Result>;

public interface IQuery<TResponse> : IRequest<Result<TResponse>>;


