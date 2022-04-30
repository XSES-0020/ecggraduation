package com.ecgproject.test;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

public class HL7test {
    /*public static void main(String[] args) {
        //定义一个返回的map存储吧，没办法
        Map<String,Object> map = new HashMap<>();

        try {
            //用以读取xml文档
            SAXReader saxReader = new SAXReader();
            //读取指定的xml文件之后返回一个Document对象，这个对象代表了整个XML文档，用于各种Dom运算。执照XML文件头所定义的编码来转换。
            Document document = saxReader.read("F:\\1.XML");

            //获取根节点：根节点是xml分析的开始，任何xml分析工作都需要从根开始
            Element rootElement = document.getRootElement();
            System.out.println("根节点的名字是:" + rootElement.getName());

            *//**
             * 对Document对象调用getRootElement()方法可以返回代表根节点的Element对象。
             * 拥有了一个Element对象后，可以对该对象调用elementIterator()方法获得它的子节点的Element对象们的一个迭代器。
             * 使用(Element)iterator.next()方法遍历一个iterator并把每个取出的元素转化为Element类型。
             *//*
            Iterator it = rootElement.elementIterator();
            while (it.hasNext()) { //如果对这个元素对象的遍历没有结束
                Element fistChild = (Element) it.next();

                //对这个元素，调用下面自己定义的getvalue方法
                getValue(fistChild);

                //然后再对这个元素创建一个iterator
                Iterator iterator = fistChild.elementIterator();
                //对这个元素，调用下面自己定义的getElementIterator方法
                getElementIterator(iterator);
            }
        } catch (DocumentException e) {
            e.printStackTrace();
        }
    }

    public static void getElementIterator(Iterator iterator) {
        while (iterator.hasNext()) {
            Element element = (Element) iterator.next();
            getValue(element);
            Iterator iterator2 = element.elementIterator();
            if (iterator2.hasNext()) {
                getElementIterator(iterator2);
            }
        }
    }

    *//**
     * 自己定义的getvalue方法，针对element对象
     * @param element
     *//*
    public static void getValue(Element element) {
        //element的attributeValue方法：取得节点的指定的属性，这里好像只定义输出了几个属性
        //根节点id
        if (null != element.attributeValue("root")) {
            System.out.println(element.attributeValue("root"));
        }
        //
        if (null != element.attributeValue("extension")) {
            System.out.println(element.attributeValue("extension"));
        }
        //
        if (null != element.attributeValue("code")) {
            System.out.println(element.attributeValue("code"));
        }
        if (null != element.attributeValue("codeSystem")) {
            System.out.println(element.attributeValue("codeSystem"));
        }
        if (null != element.attributeValue("codeSystemName")) {
            System.out.println(element.attributeValue("codeSystemName"));
        }
        if (null != element.attributeValue("displayName")) {
            System.out.println(element.attributeValue("displayName"));
        }
        if (null != element.attributeValue("value")) {
            System.out.println(element.attributeValue("value"));
        }
        if (null != element.attributeValue("xsi:type")) {
            System.out.println(element.attributeValue("xsi:type"));
        }
        if (null != element.attributeValue("unit")) {
            System.out.println(element.attributeValue("unit"));
        }
        if ("digits".equals(element.getQName().getName())) {
            System.out.println(element.getStringValue());
        }
    }*/
}

