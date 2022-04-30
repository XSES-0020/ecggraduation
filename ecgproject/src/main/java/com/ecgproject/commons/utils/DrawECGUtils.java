package com.ecgproject.commons.utils;

import java.awt.Color;
import java.awt.Graphics;
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
    public static void drawEcg(Map<String,Object> map){
        String scalebase = (String)map.get("MDC_ECG_LEAD_V6_scale");
        Double scale = Double.parseDouble(scalebase);

        String incrementbase = (String)map.get("increment");
        Double increment = Double.parseDouble(incrementbase);

        String data = (String)map.get("MDC_ECG_LEAD_V6_digit");

        try {

            byte[] imgByte = paintSingleLeadEcg(data, "PNG",scale,increment);

            // 确定写出文件的位置
            File file = new File("E:\\Test1.PNG");
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
    }

    /**
     *
     * @param data
     * @param format
     * @return
     */
    public static byte[] paintSingleLeadEcg(String data, String format, Double scale, Double increment){
        //如果是空的
        if (StringUtils.isBlank(data)) {
            return null;
        }
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
        double timepersec = 1/increment;
        //又因为每横格等于0.04s，所以每横格1mm采样次数是
        double timeperwid = timepersec*0.04f;
        //进而按像素来说就是每横格的12像素的采样次数是timeperwid次，每个像素所占的采样次数应该是
        double timeperpx = timeperwid/gridSize;
        //所以图片的宽（实际作为参数的时候代表的是像素）：每个像素x个采样，所以看这些采样能分成几组也就是几个像素
        int imageWidth = (int)Math.floor(dotNum/timeperpx);
        //图片高度，不知道随便设一下试试吧
        int imageHeight = 4*10*5;

        //纵轴缩放比，指实际电压/digit电压=scale
        //double scale = 2.52;
        //所以真正的电压就是dotList*scale
        //数据不好显示，所以要根据高1mm表示0.1mv换算

        BufferedImage bufferedImage = new BufferedImage(imageWidth, imageHeight, BufferedImage.TYPE_INT_RGB);
        Graphics graphics = bufferedImage.getGraphics();

        //设置画布大小，x和y指的是矩形左上角的位置（？）
        graphics.fillRect(0, 0, imageWidth, imageHeight);

        // 画小格子
        Color color = new Color(246, 235, 235);
        drawGrid(graphics, color, imageWidth, imageHeight,4);

        // 画中格子
        color = new Color(240, 182, 182);
        drawGrid(graphics, color, imageWidth, imageHeight,20);

        // 画大格子
        color = new Color(231, 130, 130);
        drawGrid(graphics, color, imageWidth, imageHeight,100);

        double pointSpace = 1; // 两点之间的间距
        int firstX = 0;// 第一个点的x坐标
        int firstY = 0;// 第一个点的y坐标
        int secondX = 0;// 第二个点的x坐标
        int secondY = 0;// 第二个点的y坐标
        int baseY = imageHeight/2;

        //转化一下digit数组算了
        for (int i = 0; i < imageWidth-1; i++){
            int turn1 = (int)Math.floor(i*timeperpx);
            int nData1 = Integer.parseInt(dotList.get(turn1));
            double digit1 = nData1*scale;
            //经过mv和uv转换、px和mm转换之后，y轴对应的像素坐标
            double dfy1 = (digit1/1000f)*120;

            int turn2 = (int)Math.floor((i+1)*timeperpx);
            int nData2 = Integer.parseInt(dotList.get(turn2));
            double digit2 = nData2*scale;
            //经过mv和uv转换、px和mm转换之后，y轴对应的像素坐标
            double dfy2 = (digit2/1000f)*120;

            // 设置心电图线的颜色(黑色)
            graphics.setColor(Color.BLACK);

            firstX = i;
            firstY = (0-(int)Math.round(dfy1))+baseY;
            secondX = firstX+1;
            secondY = (0-(int)Math.round(dfy2))+baseY;

            graphics.drawLine(firstX, firstY, secondX, secondY);
            // 设置下一个点的起始坐标
            firstX = secondX;
            firstY = secondY;

        }
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
