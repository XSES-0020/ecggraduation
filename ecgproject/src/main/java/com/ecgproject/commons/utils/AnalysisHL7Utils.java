package com.ecgproject.commons.utils;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.sun.org.apache.bcel.internal.generic.RETURN;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

public class AnalysisHL7Utils {
    public static Map analysisHL7(){
        Map<String,Object> map = new HashMap<>();
        //map.put("test","test");
        try {
            //用以读取xml文档
            SAXReader saxReader = new SAXReader();
            //读取指定的xml文件之后返回一个Document对象，这个对象代表了整个XML文档，用于各种Dom运算。执照XML文件头所定义的编码来转换。
            Document document = saxReader.read("F:\\1.XML");

            //获取根节点：根节点是xml分析的开始，任何xml分析工作都需要从根开始
            Element rootElement = document.getRootElement();
            System.out.println("根节点的名字是:" + rootElement.getName());

            //获取根节点下 数据元素componet节点
            Element memberCom = rootElement.element("component");
            //获取component下数据序列series节点
            Element memberSeries = memberCom.element("series");
            //获取series下数据component节点
            Element memberComponent = memberSeries.element("component");
            //获取component节点下序列集sequenceSet节点
            Element memberseq = memberComponent.element("sequenceSet");
            //获取sequenceSet下所有component节点（这里面存放真正数据）
            List<Element> elementList = memberseq.elements();
            //对于每一个component节点遍历，找出其中对应的数据
            int i = 1;
            for(Iterator it = elementList.iterator();it.hasNext();i++){
                Element component = (Element)it.next();
                Element sequence = component.element("sequence");
                //map.put(Integer.toString(i),sequence.getStringValue());
                //code里面放名字
                Element membercode = sequence.element("code");
                String code = membercode.attributeValue("code");

                //value里面放数据，如果是时间，那就放时间吧
                String time = new String("TIME_ABSOLUTE");
                if (code.equals(time)) {
                    Element membervalue = sequence.element("value");
                    //操作时间
                    Element memberhead = membervalue.element("head");
                    map.put("taketime",memberhead.attributeValue("value"));
                    //步进
                    Element memberincrement = membervalue.element("increment");
                    map.put("increment",memberincrement.attributeValue("value"));
                }else{//存储的是心电数据
                    Element membervalue = sequence.element("value");
                    String seqtype = membercode.attributeValue("code");
                    String scalename = seqtype+"_scale";
                    String digitname = seqtype+"_digit";

                    //test


                    Element memberscale = membervalue.element("scale");
                    map.put(scalename,memberscale.attributeValue("value"));
                    Element memberdigits = membervalue.element("digits");
                    map.put(digitname,memberdigits.getStringValue());
                }
            }

            /*for(String key:map.keySet()){
                System.out.println("key:"+key+"value:"+map.get(key));
            }*/

        } catch (DocumentException e) {
            e.printStackTrace();
        }

        return map;
    }

}
