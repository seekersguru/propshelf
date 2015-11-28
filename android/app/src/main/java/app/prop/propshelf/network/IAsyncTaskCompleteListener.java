/*
 * IAsyncTaskCompleteListener.java
 * Flo2Cash
 * 
 * Created by Sanket Patel on 2/18/13.
 * Copyright (c) 2013 Xerces Technologies Pvt. Ltd. All rights reserved.
 */
package app.prop.propshelf.network;

import app.prop.propshelf.model.ResponseData;

/**
 * IAsyncTaskCompleteListener contains the onTaskComplete() method.
 * When the request to server gets completed(i.e. Response got) then onTaskComplete() is called for the class
 * which implements IAsyncTaskCompleteListener interface.
*/
public interface IAsyncTaskCompleteListener<T> 
{
	public void OnTaskSuccess(ResponseData result, int count);
	public void OnTaskError(ResponseData result, int count);
}
