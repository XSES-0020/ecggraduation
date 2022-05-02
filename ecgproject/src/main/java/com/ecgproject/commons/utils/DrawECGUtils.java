package com.ecgproject.commons.utils;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;

import org.apache.commons.lang3.StringUtils;

public class DrawECGUtils {
    public static byte[] drawEcg(Map<String,Object> map){
        /*String scalebase = (String)map.get("MDC_ECG_LEAD_V6_scale");
        Double scale = Double.parseDouble(scalebase);

        String incrementbase = (String)map.get("increment");
        Double increment = Double.parseDouble(incrementbase);

        String data = (String)map.get("MDC_ECG_LEAD_V6_digit");*/

        byte[] imgByte = paintSingleLeadEcg(map, "PNG");

        try {

            // 确定写出文件的位置
            File file = new File("E:\\IDEA\\ecggraduation\\Draw\\Test.PNG");
            // 建立输出字节流
            FileOutputStream fos = new FileOutputStream(file);
            // 用FileOutputStream 的write方法写入字节数组
            fos.write(imgByte);
            System.out.println("写入成功");
            // 为了节省IO流的开销，需要关闭
            fos.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return imgByte;
    }

    /**
     *
     * @param map
     * @param format
     * @return
     */
    public static byte[] paintSingleLeadEcg(Map<String,Object> map, String format){
/*        //如果是空的
        if (StringUtils.isBlank(data)) {
            return null;
        }*/
        //先看是不是心电图文件
        if((String)map.get("type")=="1") {

            //先根据map拿到第一导联的数据和increment，来确定图片大小
            String scalebase = (String) map.get("MDC_ECG_LEAD_I_scale");
            Double scale = Double.parseDouble(scalebase);

            String incrementbase = (String) map.get("increment");
            Double increment = Double.parseDouble(incrementbase);

            String data = (String) map.get("MDC_ECG_LEAD_I_digit");


            //字符分割
            String[] strs = data.split(" ");
            System.out.println(strs.length);
            List<String> dotList = Arrays.asList(strs);
            //点总数
            int len = dotList.size();
            //每个图片画点数
            int dotNum = len;
            //每1mm 0.04s的像素值
            int gridSize = 4;
            //横轴步进
            //double increment = 0.001;
            //相当于每秒采样次数
            double timepersec = 1 / increment;
            //又因为每横格等于0.04s，所以每横格1mm采样次数是
            double timeperwid = timepersec * 0.04f;
            //进而按像素来说就是每横格的12像素的采样次数是timeperwid次，每个像素所占的采样次数应该是
            double timeperpx = timeperwid / gridSize;
            //所以图片的宽（实际作为参数的时候代表的是像素）：每个像素x个采样，所以看这些采样能分成几组也就是几个像素
            int imageWidth = (int) Math.floor(dotNum / timeperpx);
            //图片高度，不知道随便设一下试试吧
            int imageHeight = gridSize * 4 * 5 * 12;
            //实际的边 方便1：1展示
            int imageEdge = imageWidth;
            if (imageHeight >= imageWidth) {
                imageEdge = imageHeight;
            }


            //纵轴缩放比，指实际电压/digit电压=scale
            //double scale = 2.52;
            //所以真正的电压就是dotList*scale
            //数据不好显示，所以要根据高1mm表示0.1mv换算

            BufferedImage bufferedImage = new BufferedImage(imageEdge, imageEdge, BufferedImage.TYPE_INT_RGB);
            Graphics graphics = bufferedImage.getGraphics();
            Graphics2D graphics2D = (Graphics2D) bufferedImage.getGraphics();
            graphics2D.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);

            //设置画布大小，x和y指的是矩形左上角的位置（？）
            graphics.fillRect(0, 0, imageEdge, imageEdge);

            // 画小格子
            Color color = new Color(246, 235, 235);
            drawGrid(graphics, color, imageEdge, imageEdge, 4);

            // 画中格子
            color = new Color(240, 182, 182);
            drawGrid(graphics, color, imageEdge, imageEdge, 20);

            // 画大格子
            color = new Color(231, 130, 130);
            drawGrid(graphics, color, imageEdge, imageEdge, 100);

            //至此，画布的基本设置已经完成了，下面就是循环来画图

            //画Ⅰ导联

            double pointSpace = 1; // 两点之间的间距
            int firstX = 0;// 第一个点的x坐标
            int firstY = 0;// 第一个点的y坐标
            int secondX = 0;// 第二个点的x坐标
            int secondY = 0;// 第二个点的y坐标
            int baseY = imageHeight / 24;
            graphics2D.setColor(Color.BLACK);
            graphics2D.setFont(new Font(null, Font.PLAIN, 10));
            graphics2D.drawString("I", 8, baseY - 4);

            //转化一下digit数组算了
            for (int i = 0; i < imageWidth - 1; i++) {
                int turn1 = (int) Math.floor(i * timeperpx);
                int nData1 = Integer.parseInt(dotList.get(turn1));
                //10mm/mv
                double digit1 = (nData1 / 1000f) * 10;
                //double digit1 = nData1*scale;
                //经过mv和uv转换、px和mm转换之后，y轴对应的像素坐标
                double dfy1 = digit1 * gridSize * scale;

                int turn2 = (int) Math.floor((i + 1) * timeperpx);
                int nData2 = Integer.parseInt(dotList.get(turn2));
                double digit2 = (nData2 / 1000f) * 10;
                //经过mv和uv转换、px和mm转换之后，y轴对应的像素坐标
                double dfy2 = digit2 * gridSize * scale;
                // 设置心电图线的颜色(黑色)
                graphics.setColor(Color.BLACK);

                firstX = i;
                firstY = baseY - (int) Math.round(dfy1);
                secondX = firstX + 1;
                secondY = baseY - (int) Math.round(dfy2);

                graphics.drawLine(firstX, firstY, secondX, secondY);
                // 设置下一个点的起始坐标
                firstX = secondX;
                firstY = secondY;

            }


            //画Ⅱ导联

            scalebase = (String) map.get("MDC_ECG_LEAD_II_scale");
            scale = Double.parseDouble(scalebase);


            data = (String) map.get("MDC_ECG_LEAD_II_digit");
            //字符分割
            strs = data.split(" ");
            System.out.println(strs.length);
            dotList = Arrays.asList(strs);

            firstX = 0;// 第一个点的x坐标
            firstY = 0;// 第一个点的y坐标
            secondX = 0;// 第二个点的x坐标
            secondY = 0;// 第二个点的y坐标
            baseY = imageHeight / 24 * 3;
            graphics2D.setColor(Color.BLACK);
            graphics2D.setFont(new Font(null, Font.PLAIN, 10));
            graphics2D.drawString("II", 8, baseY - 4);

            //转化一下digit数组算了
            for (int i = 0; i < imageWidth - 1; i++) {
                int turn1 = (int) Math.floor(i * timeperpx);
                int nData1 = Integer.parseInt(dotList.get(turn1));
                //10mm/mv
                double digit1 = (nData1 / 1000f) * 10;
                //double digit1 = nData1*scale;
                //经过mv和uv转换、px和mm转换之后，y轴对应的像素坐标
                double dfy1 = digit1 * gridSize * scale;

                int turn2 = (int) Math.floor((i + 1) * timeperpx);
                int nData2 = Integer.parseInt(dotList.get(turn2));
                double digit2 = (nData2 / 1000f) * 10;
                //经过mv和uv转换、px和mm转换之后，y轴对应的像素坐标
                double dfy2 = digit2 * gridSize * scale;
                // 设置心电图线的颜色(黑色)
                graphics.setColor(Color.BLACK);

                firstX = i;
                firstY = baseY - (int) Math.round(dfy1);
                secondX = firstX + 1;
                secondY = baseY - (int) Math.round(dfy2);

                graphics.drawLine(firstX, firstY, secondX, secondY);
                // 设置下一个点的起始坐标
                firstX = secondX;
                firstY = secondY;

            }

            //画Ⅲ导联

            scalebase = (String) map.get("MDC_ECG_LEAD_III_scale");
            scale = Double.parseDouble(scalebase);


            data = (String) map.get("MDC_ECG_LEAD_III_digit");
            //字符分割
            strs = data.split(" ");
            System.out.println(strs.length);
            dotList = Arrays.asList(strs);

            firstX = 0;// 第一个点的x坐标
            firstY = 0;// 第一个点的y坐标
            secondX = 0;// 第二个点的x坐标
            secondY = 0;// 第二个点的y坐标
            baseY = imageHeight / 24 * 5;
            graphics2D.setColor(Color.BLACK);
            graphics2D.setFont(new Font(null, Font.PLAIN, 10));
            graphics2D.drawString("III", 8, baseY - 4);

            //转化一下digit数组算了
            for (int i = 0; i < imageWidth - 1; i++) {
                int turn1 = (int) Math.floor(i * timeperpx);
                int nData1 = Integer.parseInt(dotList.get(turn1));
                //10mm/mv
                double digit1 = (nData1 / 1000f) * 10;
                //double digit1 = nData1*scale;
                //经过mv和uv转换、px和mm转换之后，y轴对应的像素坐标
                double dfy1 = digit1 * gridSize * scale;

                int turn2 = (int) Math.floor((i + 1) * timeperpx);
                int nData2 = Integer.parseInt(dotList.get(turn2));
                double digit2 = (nData2 / 1000f) * 10;
                //经过mv和uv转换、px和mm转换之后，y轴对应的像素坐标
                double dfy2 = digit2 * gridSize * scale;
                // 设置心电图线的颜色(黑色)
                graphics.setColor(Color.BLACK);

                firstX = i;
                firstY = baseY - (int) Math.round(dfy1);
                secondX = firstX + 1;
                secondY = baseY - (int) Math.round(dfy2);

                graphics.drawLine(firstX, firstY, secondX, secondY);
                // 设置下一个点的起始坐标
                firstX = secondX;
                firstY = secondY;

            }

            //画AVR导联

            scalebase = (String) map.get("MDC_ECG_LEAD_AVR_scale");
            scale = Double.parseDouble(scalebase);


            data = (String) map.get("MDC_ECG_LEAD_AVR_digit");
            //字符分割
            strs = data.split(" ");
            System.out.println(strs.length);
            dotList = Arrays.asList(strs);

            firstX = 0;// 第一个点的x坐标
            firstY = 0;// 第一个点的y坐标
            secondX = 0;// 第二个点的x坐标
            secondY = 0;// 第二个点的y坐标
            baseY = imageHeight / 24 * 7;
            graphics2D.setColor(Color.BLACK);
            graphics2D.setFont(new Font(null, Font.PLAIN, 10));
            graphics2D.drawString("AVR", 8, baseY - 4);

            //转化一下digit数组算了
            for (int i = 0; i < imageWidth - 1; i++) {
                int turn1 = (int) Math.floor(i * timeperpx);
                int nData1 = Integer.parseInt(dotList.get(turn1));
                //10mm/mv
                double digit1 = (nData1 / 1000f) * 10;
                //double digit1 = nData1*scale;
                //经过mv和uv转换、px和mm转换之后，y轴对应的像素坐标
                double dfy1 = digit1 * gridSize * scale;

                int turn2 = (int) Math.floor((i + 1) * timeperpx);
                int nData2 = Integer.parseInt(dotList.get(turn2));
                double digit2 = (nData2 / 1000f) * 10;
                //经过mv和uv转换、px和mm转换之后，y轴对应的像素坐标
                double dfy2 = digit2 * gridSize * scale;
                // 设置心电图线的颜色(黑色)
                graphics.setColor(Color.BLACK);

                firstX = i;
                firstY = baseY - (int) Math.round(dfy1);
                secondX = firstX + 1;
                secondY = baseY - (int) Math.round(dfy2);

                graphics.drawLine(firstX, firstY, secondX, secondY);
                // 设置下一个点的起始坐标
                firstX = secondX;
                firstY = secondY;

            }

            //画AVL导联

            scalebase = (String) map.get("MDC_ECG_LEAD_AVL_scale");
            scale = Double.parseDouble(scalebase);


            data = (String) map.get("MDC_ECG_LEAD_AVL_digit");
            //字符分割
            strs = data.split(" ");
            System.out.println(strs.length);
            dotList = Arrays.asList(strs);

            firstX = 0;// 第一个点的x坐标
            firstY = 0;// 第一个点的y坐标
            secondX = 0;// 第二个点的x坐标
            secondY = 0;// 第二个点的y坐标
            baseY = imageHeight / 24 * 9;
            graphics2D.setColor(Color.BLACK);
            graphics2D.setFont(new Font(null, Font.PLAIN, 10));
            graphics2D.drawString("AVL", 8, baseY - 4);

            //转化一下digit数组算了
            for (int i = 0; i < imageWidth - 1; i++) {
                int turn1 = (int) Math.floor(i * timeperpx);
                int nData1 = Integer.parseInt(dotList.get(turn1));
                //10mm/mv
                double digit1 = (nData1 / 1000f) * 10;
                //double digit1 = nData1*scale;
                //经过mv和uv转换、px和mm转换之后，y轴对应的像素坐标
                double dfy1 = digit1 * gridSize * scale;

                int turn2 = (int) Math.floor((i + 1) * timeperpx);
                int nData2 = Integer.parseInt(dotList.get(turn2));
                double digit2 = (nData2 / 1000f) * 10;
                //经过mv和uv转换、px和mm转换之后，y轴对应的像素坐标
                double dfy2 = digit2 * gridSize * scale;
                // 设置心电图线的颜色(黑色)
                graphics.setColor(Color.BLACK);

                firstX = i;
                firstY = baseY - (int) Math.round(dfy1);
                secondX = firstX + 1;
                secondY = baseY - (int) Math.round(dfy2);

                graphics.drawLine(firstX, firstY, secondX, secondY);
                // 设置下一个点的起始坐标
                firstX = secondX;
                firstY = secondY;

            }

            //画AVF导联

            scalebase = (String) map.get("MDC_ECG_LEAD_AVF_scale");
            scale = Double.parseDouble(scalebase);


            data = (String) map.get("MDC_ECG_LEAD_AVF_digit");
            //字符分割
            strs = data.split(" ");
            System.out.println(strs.length);
            dotList = Arrays.asList(strs);

            firstX = 0;// 第一个点的x坐标
            firstY = 0;// 第一个点的y坐标
            secondX = 0;// 第二个点的x坐标
            secondY = 0;// 第二个点的y坐标
            baseY = imageHeight / 24 * 11;
            graphics2D.setColor(Color.BLACK);
            graphics2D.setFont(new Font(null, Font.PLAIN, 10));
            graphics2D.drawString("AVF", 8, baseY - 4);

            //转化一下digit数组算了
            for (int i = 0; i < imageWidth - 1; i++) {
                int turn1 = (int) Math.floor(i * timeperpx);
                int nData1 = Integer.parseInt(dotList.get(turn1));
                //10mm/mv
                double digit1 = (nData1 / 1000f) * 10;
                //double digit1 = nData1*scale;
                //经过mv和uv转换、px和mm转换之后，y轴对应的像素坐标
                double dfy1 = digit1 * gridSize * scale;

                int turn2 = (int) Math.floor((i + 1) * timeperpx);
                int nData2 = Integer.parseInt(dotList.get(turn2));
                double digit2 = (nData2 / 1000f) * 10;
                //经过mv和uv转换、px和mm转换之后，y轴对应的像素坐标
                double dfy2 = digit2 * gridSize * scale;
                // 设置心电图线的颜色(黑色)
                graphics.setColor(Color.BLACK);

                firstX = i;
                firstY = baseY - (int) Math.round(dfy1);
                secondX = firstX + 1;
                secondY = baseY - (int) Math.round(dfy2);

                graphics.drawLine(firstX, firstY, secondX, secondY);
                // 设置下一个点的起始坐标
                firstX = secondX;
                firstY = secondY;

            }

            //画V1导联

            scalebase = (String) map.get("MDC_ECG_LEAD_V1_scale");
            scale = Double.parseDouble(scalebase);


            data = (String) map.get("MDC_ECG_LEAD_V1_digit");
            //字符分割
            strs = data.split(" ");
            System.out.println(strs.length);
            dotList = Arrays.asList(strs);

            firstX = 0;// 第一个点的x坐标
            firstY = 0;// 第一个点的y坐标
            secondX = 0;// 第二个点的x坐标
            secondY = 0;// 第二个点的y坐标
            baseY = imageHeight / 24 * 13;
            graphics2D.setColor(Color.BLACK);
            graphics2D.setFont(new Font(null, Font.PLAIN, 10));
            graphics2D.drawString("V1", 8, baseY - 4);

            //转化一下digit数组算了
            for (int i = 0; i < imageWidth - 1; i++) {
                int turn1 = (int) Math.floor(i * timeperpx);
                int nData1 = Integer.parseInt(dotList.get(turn1));
                //10mm/mv
                double digit1 = (nData1 / 1000f) * 10;
                //double digit1 = nData1*scale;
                //经过mv和uv转换、px和mm转换之后，y轴对应的像素坐标
                double dfy1 = digit1 * gridSize * scale;

                int turn2 = (int) Math.floor((i + 1) * timeperpx);
                int nData2 = Integer.parseInt(dotList.get(turn2));
                double digit2 = (nData2 / 1000f) * 10;
                //经过mv和uv转换、px和mm转换之后，y轴对应的像素坐标
                double dfy2 = digit2 * gridSize * scale;
                // 设置心电图线的颜色(黑色)
                graphics.setColor(Color.BLACK);

                firstX = i;
                firstY = baseY - (int) Math.round(dfy1);
                secondX = firstX + 1;
                secondY = baseY - (int) Math.round(dfy2);

                graphics.drawLine(firstX, firstY, secondX, secondY);
                // 设置下一个点的起始坐标
                firstX = secondX;
                firstY = secondY;

            }

            //画V2导联

            scalebase = (String) map.get("MDC_ECG_LEAD_V2_scale");
            scale = Double.parseDouble(scalebase);


            data = (String) map.get("MDC_ECG_LEAD_V2_digit");
            //字符分割
            strs = data.split(" ");
            System.out.println(strs.length);
            dotList = Arrays.asList(strs);

            firstX = 0;// 第一个点的x坐标
            firstY = 0;// 第一个点的y坐标
            secondX = 0;// 第二个点的x坐标
            secondY = 0;// 第二个点的y坐标
            baseY = imageHeight / 24 * 15;
            graphics2D.setColor(Color.BLACK);
            graphics2D.setFont(new Font(null, Font.PLAIN, 10));
            graphics2D.drawString("V2", 8, baseY - 4);

            //转化一下digit数组算了
            for (int i = 0; i < imageWidth - 1; i++) {
                int turn1 = (int) Math.floor(i * timeperpx);
                int nData1 = Integer.parseInt(dotList.get(turn1));
                //10mm/mv
                double digit1 = (nData1 / 1000f) * 10;
                //double digit1 = nData1*scale;
                //经过mv和uv转换、px和mm转换之后，y轴对应的像素坐标
                double dfy1 = digit1 * gridSize * scale;

                int turn2 = (int) Math.floor((i + 1) * timeperpx);
                int nData2 = Integer.parseInt(dotList.get(turn2));
                double digit2 = (nData2 / 1000f) * 10;
                //经过mv和uv转换、px和mm转换之后，y轴对应的像素坐标
                double dfy2 = digit2 * gridSize * scale;
                // 设置心电图线的颜色(黑色)
                graphics.setColor(Color.BLACK);

                firstX = i;
                firstY = baseY - (int) Math.round(dfy1);
                secondX = firstX + 1;
                secondY = baseY - (int) Math.round(dfy2);

                graphics.drawLine(firstX, firstY, secondX, secondY);
                // 设置下一个点的起始坐标
                firstX = secondX;
                firstY = secondY;

            }

            //画V3导联

            scalebase = (String) map.get("MDC_ECG_LEAD_V3_scale");
            scale = Double.parseDouble(scalebase);


            data = (String) map.get("MDC_ECG_LEAD_V3_digit");
            //字符分割
            strs = data.split(" ");
            System.out.println(strs.length);
            dotList = Arrays.asList(strs);

            firstX = 0;// 第一个点的x坐标
            firstY = 0;// 第一个点的y坐标
            secondX = 0;// 第二个点的x坐标
            secondY = 0;// 第二个点的y坐标
            baseY = imageHeight / 24 * 17;
            graphics2D.setColor(Color.BLACK);
            graphics2D.setFont(new Font(null, Font.PLAIN, 10));
            graphics2D.drawString("V3", 8, baseY - 4);

            //转化一下digit数组算了
            for (int i = 0; i < imageWidth - 1; i++) {
                int turn1 = (int) Math.floor(i * timeperpx);
                int nData1 = Integer.parseInt(dotList.get(turn1));
                //10mm/mv
                double digit1 = (nData1 / 1000f) * 10;
                //double digit1 = nData1*scale;
                //经过mv和uv转换、px和mm转换之后，y轴对应的像素坐标
                double dfy1 = digit1 * gridSize * scale;

                int turn2 = (int) Math.floor((i + 1) * timeperpx);
                int nData2 = Integer.parseInt(dotList.get(turn2));
                double digit2 = (nData2 / 1000f) * 10;
                //经过mv和uv转换、px和mm转换之后，y轴对应的像素坐标
                double dfy2 = digit2 * gridSize * scale;
                // 设置心电图线的颜色(黑色)
                graphics.setColor(Color.BLACK);

                firstX = i;
                firstY = baseY - (int) Math.round(dfy1);
                secondX = firstX + 1;
                secondY = baseY - (int) Math.round(dfy2);

                graphics.drawLine(firstX, firstY, secondX, secondY);
                // 设置下一个点的起始坐标
                firstX = secondX;
                firstY = secondY;

            }

            //画V4导联

            scalebase = (String) map.get("MDC_ECG_LEAD_V4_scale");
            scale = Double.parseDouble(scalebase);


            data = (String) map.get("MDC_ECG_LEAD_V4_digit");
            //字符分割
            strs = data.split(" ");
            System.out.println(strs.length);
            dotList = Arrays.asList(strs);

            firstX = 0;// 第一个点的x坐标
            firstY = 0;// 第一个点的y坐标
            secondX = 0;// 第二个点的x坐标
            secondY = 0;// 第二个点的y坐标
            baseY = imageHeight / 24 * 19;
            graphics2D.setColor(Color.BLACK);
            graphics2D.setFont(new Font(null, Font.PLAIN, 10));
            graphics2D.drawString("V4", 8, baseY - 4);

            //转化一下digit数组算了
            for (int i = 0; i < imageWidth - 1; i++) {
                int turn1 = (int) Math.floor(i * timeperpx);
                int nData1 = Integer.parseInt(dotList.get(turn1));
                //10mm/mv
                double digit1 = (nData1 / 1000f) * 10;
                //double digit1 = nData1*scale;
                //经过mv和uv转换、px和mm转换之后，y轴对应的像素坐标
                double dfy1 = digit1 * gridSize * scale;

                int turn2 = (int) Math.floor((i + 1) * timeperpx);
                int nData2 = Integer.parseInt(dotList.get(turn2));
                double digit2 = (nData2 / 1000f) * 10;
                //经过mv和uv转换、px和mm转换之后，y轴对应的像素坐标
                double dfy2 = digit2 * gridSize * scale;
                // 设置心电图线的颜色(黑色)
                graphics.setColor(Color.BLACK);

                firstX = i;
                firstY = baseY - (int) Math.round(dfy1);
                secondX = firstX + 1;
                secondY = baseY - (int) Math.round(dfy2);

                graphics.drawLine(firstX, firstY, secondX, secondY);
                // 设置下一个点的起始坐标
                firstX = secondX;
                firstY = secondY;

            }

            //画V5导联

            scalebase = (String) map.get("MDC_ECG_LEAD_V5_scale");
            scale = Double.parseDouble(scalebase);


            data = (String) map.get("MDC_ECG_LEAD_V5_digit");
            //字符分割
            strs = data.split(" ");
            System.out.println(strs.length);
            dotList = Arrays.asList(strs);

            firstX = 0;// 第一个点的x坐标
            firstY = 0;// 第一个点的y坐标
            secondX = 0;// 第二个点的x坐标
            secondY = 0;// 第二个点的y坐标
            baseY = imageHeight / 24 * 21;
            graphics2D.setColor(Color.BLACK);
            graphics2D.setFont(new Font(null, Font.PLAIN, 10));
            graphics2D.drawString("V5", 8, baseY - 4);

            //转化一下digit数组算了
            for (int i = 0; i < imageWidth - 1; i++) {
                int turn1 = (int) Math.floor(i * timeperpx);
                int nData1 = Integer.parseInt(dotList.get(turn1));
                //10mm/mv
                double digit1 = (nData1 / 1000f) * 10;
                //double digit1 = nData1*scale;
                //经过mv和uv转换、px和mm转换之后，y轴对应的像素坐标
                double dfy1 = digit1 * gridSize * scale;

                int turn2 = (int) Math.floor((i + 1) * timeperpx);
                int nData2 = Integer.parseInt(dotList.get(turn2));
                double digit2 = (nData2 / 1000f) * 10;
                //经过mv和uv转换、px和mm转换之后，y轴对应的像素坐标
                double dfy2 = digit2 * gridSize * scale;
                // 设置心电图线的颜色(黑色)
                graphics.setColor(Color.BLACK);

                firstX = i;
                firstY = baseY - (int) Math.round(dfy1);
                secondX = firstX + 1;
                secondY = baseY - (int) Math.round(dfy2);

                graphics.drawLine(firstX, firstY, secondX, secondY);
                // 设置下一个点的起始坐标
                firstX = secondX;
                firstY = secondY;

            }

            //画V6导联

            scalebase = (String) map.get("MDC_ECG_LEAD_V6_scale");
            scale = Double.parseDouble(scalebase);


            data = (String) map.get("MDC_ECG_LEAD_V6_digit");
            //字符分割
            strs = data.split(" ");
            System.out.println(strs.length);
            dotList = Arrays.asList(strs);

            firstX = 0;// 第一个点的x坐标
            firstY = 0;// 第一个点的y坐标
            secondX = 0;// 第二个点的x坐标
            secondY = 0;// 第二个点的y坐标
            baseY = imageHeight / 24 * 23;
            graphics2D.setColor(Color.BLACK);
            graphics2D.setFont(new Font(null, Font.PLAIN, 10));
            graphics2D.drawString("V6", 8, baseY - 4);

            //转化一下digit数组算了
            for (int i = 0; i < imageWidth - 1; i++) {
                int turn1 = (int) Math.floor(i * timeperpx);
                int nData1 = Integer.parseInt(dotList.get(turn1));
                //10mm/mv
                double digit1 = (nData1 / 1000f) * 10;
                //double digit1 = nData1*scale;
                //经过mv和uv转换、px和mm转换之后，y轴对应的像素坐标
                double dfy1 = digit1 * gridSize * scale;

                int turn2 = (int) Math.floor((i + 1) * timeperpx);
                int nData2 = Integer.parseInt(dotList.get(turn2));
                double digit2 = (nData2 / 1000f) * 10;
                //经过mv和uv转换、px和mm转换之后，y轴对应的像素坐标
                double dfy2 = digit2 * gridSize * scale;
                // 设置心电图线的颜色(黑色)
                graphics.setColor(Color.BLACK);

                firstX = i;
                firstY = baseY - (int) Math.round(dfy1);
                secondX = firstX + 1;
                secondY = baseY - (int) Math.round(dfy2);

                graphics.drawLine(firstX, firstY, secondX, secondY);
                // 设置下一个点的起始坐标
                firstX = secondX;
                firstY = secondY;

            }

            graphics2D.setColor(Color.BLACK);
            graphics2D.setFont(new Font(null, Font.PLAIN, 20));
            graphics2D.drawString("25mm/s, 10mm/mv", imageEdge / 4, imageEdge - 8);

            String str = (String) map.get("taketime");
            String dateStr = str.substring(0, 4) + "/" + str.substring(4, 6) + "/" + str.substring(6, 8) + " " + str.substring(8, 10) + ":" + str.substring(10, 12) + ":" + str.substring(12, 14);
            graphics2D.drawString(dateStr, imageEdge / 4 * 3, imageEdge - 8);

            graphics2D.dispose();
            graphics.dispose();

            // 图片写入stream
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            try {
                if (StringUtils.isBlank(format)) {
                    format = "PNG";
                }
                ImageIO.write(bufferedImage, format, out);
            } catch (IOException e) {
                e.printStackTrace();
                return null;
            }

            return out.toByteArray();
        }else{
            return null;
        }
    }



    /**
     * 画网格线
     *
     * @param graphics
     * @param color
     *            线的颜色
     * @param width
     *            图片宽
     * @param step
     *            格子宽度
     */
    private static void drawGrid(Graphics graphics, Color color, int width, int high, int step) {

        graphics.setColor(color);
        // 画竖线
        for (int x = 0; x < width; x += step) {
            graphics.drawLine(x, 0, x, high);
        }
        // 画横线(10像素的白边)
        for (int y = 0; y < high; y += step) {
            graphics.drawLine(0, y, width, y);
        }
    }
}
