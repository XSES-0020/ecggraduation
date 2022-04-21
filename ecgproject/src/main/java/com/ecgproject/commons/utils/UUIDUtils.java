package com.ecgproject.commons.utils;

import java.util.UUID;

public class UUIDUtils {
    public static String getUUID(){
        //获取uuid
        return UUID.randomUUID().toString().replaceAll("-","");
    }
}
