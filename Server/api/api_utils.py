from click import option
from flask import request

def get_params(params : list[str], request):
    """
    Extract the given parameters from the request headers.

    If all the parameters are present in the form, the code 200 is returned as well as the list of parameters. Otherwise code 400 is returned along with an error message.

    """
    result = []
    okay = True
    missing = []
    for i in params:
        
        data = request.headers.get(i)
        if not data:
            okay = False
            missing.append(i)
        else:
            result.append(data)
    if okay:
        return 200, result
    else:
        return 400, f"Some form data keys are missing : {', '.join(missing)}"

def error(text : str):
    """
    Returns the json body that need to be sent in response when an error occured.
    """
    return {"error" : text}


def get_headers(keys : list[str], additional_error_message : str = None):
    def decorator(func):
        def wrapper(*args, **kwargs):
            code, output = get_params(keys, request)
            if code != 200:
                return error(output + (additional_error_message if additional_error_message else "")), code
            return func(output = output,*args, *kwargs)
        wrapper.__name__ = func.__name__
        return wrapper
    return decorator

def get_optional_header(keys : list[str]):
    """
    Gets the value associated with the keys. If the header does not exist, a None value is set in the dictionary and no error is raised.
    
    Pass the values of the headers as a dictionary using the parameter name `optional`.
    """
    def decorator(func):
        def wrapper(*args, **kwargs):
            optional_parameters = {}
            for i in keys:
                data = request.headers.get(i)
                optional_parameters[i] = data
            return func(*args, optional = optional_parameters, **kwargs)
        
        wrapper.__name__ = func.__name__
        return wrapper
    return decorator




