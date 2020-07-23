package main

import (
	"context"
	"fmt"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
	"github.com/aws/aws-sdk-go/service/s3/s3manager"
)

func handler(ctx context.Context, s3Event events.S3Event) {
	for i, record := range s3Event.Records {
		fmt.Println("record", i)
		fmt.Printf("record.S3: %+v\n", record.S3)
		fmt.Printf("record.S3.Bucket: %+v\n", record.S3.Bucket)
		fmt.Printf("record.S3.Object: %+v\n", record.S3.Object)

		// Create a downloader with the session and default options
		downloader := s3manager.NewDownloader(session.Must(session.NewSession()))

		// Write the contents of S3 Object to the file
		b := aws.NewWriteAtBuffer([]byte{})
		input := &s3.GetObjectInput{
			Bucket: aws.String(record.S3.Bucket.Name),
			Key:    aws.String(record.S3.Object.Key),
		}
		n, err := downloader.Download(b, input)
		if err != nil {
			panic(err)
		}
		fmt.Printf("read: %d bytes, len(b) = %d\n", n, len(b.Bytes()))
	}
}

func main() {
	// Make the handler available for Remote Procedure Call by AWS Lambda
	lambda.Start(handler)
}
